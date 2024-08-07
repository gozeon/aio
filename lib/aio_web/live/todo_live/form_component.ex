defmodule AioWeb.TodoLive.FormComponent do
  alias Aio.Event
  use AioWeb, :live_component

  alias Aio.Model

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage todo records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="todo-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a value"
          options={Ecto.Enum.values(Aio.Model.Todo, :status)}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Todo</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{todo: todo} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Model.change_todo(todo))
     end)}
  end

  @impl true
  def handle_event("validate", %{"todo" => todo_params}, socket) do
    changeset = Model.change_todo(socket.assigns.todo, todo_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"todo" => todo_params}, socket) do
    save_todo(socket, socket.assigns.action, todo_params)
  end

  defp save_todo(socket, :edit, todo_params) do
    case Model.update_todo(socket.assigns.todo, todo_params) do
      {:ok, todo} ->
        # notify_parent({:saved, todo})
        Model.broadcast(socket.assigns.scope, %Event.TodoUpdate{todo: todo})

        {:noreply,
         socket
         |> put_flash(:info, "Todo updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_todo(socket, :new, todo_params) do
    case Model.create_todo(socket.assigns.scope, todo_params) do
      {:ok, todo} ->
        # notify_parent({:saved, todo})
        Model.broadcast(socket.assigns.scope, %Event.TodoAdd{todo: todo})

        {:noreply,
         socket
         |> put_flash(:info, "Todo created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  # defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
