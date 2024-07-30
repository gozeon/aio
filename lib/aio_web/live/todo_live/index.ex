defmodule AioWeb.TodoLive.Index do
  use AioWeb, :live_view

  alias Aio.Model
  alias Aio.Model.Todo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :todos, Model.list_todos(socket.assigns.scope))}
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
  def handle_info({AioWeb.TodoLive.FormComponent, {:saved, todo}}, socket) do
    {:noreply, stream_insert(socket, :todos, todo)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Model.get_todo!(socket.assigns.scope, id)
    {:ok, _} = Model.delete_todo(todo)

    {:noreply, stream_delete(socket, :todos, todo)}
  end
end
