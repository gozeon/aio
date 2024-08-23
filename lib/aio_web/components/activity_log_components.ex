defmodule AioWeb.ActivityLogComponents do
  use AioWeb, :live_component

  alias Aio.Model

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>Activity Log</.header>
      <.list>
        <:item :for={item <- @logs} title={item.inserted_at}>
          <%= item.user.email %> <%= item.action %> <%= item.subject %>
        </:item>
      </.list>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    socket = socket |> assign(assigns) |> assign(:logs, Model.get_activity_logs_latest())
    {:ok, socket}
  end
end
