defmodule AioWeb.ActivityLogLive.FormComponent do
  use AioWeb, :live_component

  alias Aio.Model

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage activity_log records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="activity_log-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:meta]} type="hidden" />
        <.input field={@form[:action]} type="text" label="Action" />
        <.input field={@form[:subject]} type="text" label="Subject" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Activity log</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{activity_log: activity_log} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Model.change_activity_log(activity_log))
     end)}
  end

  @impl true
  def handle_event("validate", %{"activity_log" => activity_log_params}, socket) do
    changeset = Model.change_activity_log(socket.assigns.activity_log, activity_log_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"activity_log" => activity_log_params}, socket) do
    save_activity_log(socket, socket.assigns.action, activity_log_params)
  end

  defp save_activity_log(socket, :edit, activity_log_params) do
    case Model.update_activity_log(
           socket.assigns.scope,
           socket.assigns.activity_log,
           activity_log_params
         ) do
      {:ok, activity_log} ->
        notify_parent({:saved, activity_log})

        {:noreply,
         socket
         |> put_flash(:info, "Activity log updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_activity_log(socket, :new, activity_log_params) do
    case Model.create_activity_log(socket.assigns.scope, activity_log_params) do
      {:ok, activity_log} ->
        notify_parent({:saved, activity_log})

        {:noreply,
         socket
         |> put_flash(:info, "Activity log created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
