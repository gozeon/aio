defmodule AioWeb.ActivityLogLive.Show do
  use AioWeb, :live_view

  alias Aio.Model

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:activity_log, Model.get_activity_log!(id))}
  end

  defp page_title(:show), do: "Show Activity log"
  defp page_title(:edit), do: "Edit Activity log"
end
