defmodule AioWeb.TodoLive.Index do
  use AioWeb, :live_view

  alias Aio.Event
  alias Aio.Model
  alias Aio.Model.Todo

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Model.subscribe(socket.assigns.scope)
    end

    socket =
      socket
      |> stream(:todos, Model.list_todos(socket.assigns.scope))
      |> assign(:logId, Ecto.UUID.generate())

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo")
    |> assign(:todo, Model.get_todo!(socket.assigns.scope, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo")
    |> assign(:todo, %Todo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todos")
    |> assign(:todo, nil)
  end

  @impl true
  def handle_info({Aio.Model, %Event.TodoAdd{todo: todo} = _event}, socket) do
    send(self(), {__MODULE__, {:log, "add", todo}})
    {:noreply, stream_insert(socket, :todos, todo)}
  end

  @impl true
  def handle_info({Aio.Model, %Event.TodoDelete{todo: todo} = _event}, socket) do
    send(self(), {__MODULE__, {:log, "delete", todo}})
    {:noreply, stream_delete(socket, :todos, todo)}
  end

  @impl true
  def handle_info({Aio.Model, %Event.TodoUpdate{todo: todo} = _event}, socket) do
    send(self(), {__MODULE__, {:log, "update", todo}})
    {:noreply, stream_insert(socket, :todos, todo)}
  end

  @impl true
  def handle_info({__MODULE__, {:log, action, todo}}, socket) do
    Model.create_activity_log(socket.assigns.scope, %{
      "action" => action,
      "subject" => "todo",
      "meta" => Jason.encode!(%{"todo" => todo})
    })

    # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveComponent.html#module-livecomponent-as-the-source-of-truth
    # 改变component的传入值，触发组件里的update
    socket = socket |> assign(:logId, Ecto.UUID.generate())
    {:noreply, socket}
  end

  @impl true
  def handle_info({AioWeb.TodoLive.FormComponent, {:saved, todo}}, socket) do
    {:noreply, stream_insert(socket, :todos, todo)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Model.get_todo!(socket.assigns.scope, id)
    {:ok, _} = Model.delete_todo(todo)

    Model.broadcast(socket.assigns.scope, %Event.TodoDelete{todo: todo})

    {:noreply, socket}
  end
end
