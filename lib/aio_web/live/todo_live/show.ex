defmodule AioWeb.TodoLive.Show do
  use AioWeb, :live_view

  alias Aio.Model
  alias Aio.Event

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Model.subscribe(socket.assigns.scope)
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:todo, Model.get_todo!(socket.assigns.scope, id))}
  end

  @impl true
  def handle_info({Aio.Model, %Event.TodoUpdate{todo: todo} = _event}, socket) do
    send(self(), {__MODULE__, {:log, "update", todo}})
    socket =
      socket
      |> put_flash(:info, "Todo has Changed")
      |> assign(:todo, todo)

    {:noreply, socket}
  end

  @impl true
  def handle_info({Aio.Model, %Event.TodoDelete{todo: todo} = _event}, socket) do
    send(self(), {__MODULE__, {:log, "delete", todo}})
    socket =
      socket
      |> put_flash(:info, "Todo has Deleted")
      |> push_navigate(to: ~p"/todos", replace: true)

    {:noreply, socket}
  end

  @impl true
  def handle_info({__MODULE__, {:log, action, todo}}, socket) do
    Model.create_activity_log(socket.assigns.scope, %{
      "action" => action,
      "subject" => "todo",
      "meta" => Jason.encode!(%{"todo" => todo})
    })

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Todo"
  defp page_title(:edit), do: "Edit Todo"
end
