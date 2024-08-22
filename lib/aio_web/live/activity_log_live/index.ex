defmodule AioWeb.ActivityLogLive.Index do
  use AioWeb, :live_view

  alias Aio.Model
  alias Aio.Model.ActivityLog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :activity_logs, Model.list_activity_logs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity log")
    |> assign(:activity_log, Model.get_activity_log!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Activity log")
    |> assign(:activity_log, %ActivityLog{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activity logs")
    |> assign(:activity_log, nil)
  end

  @impl true
  def handle_info({AioWeb.ActivityLogLive.FormComponent, {:saved, activity_log}}, socket) do
    {:noreply, stream_insert(socket, :activity_logs, activity_log)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity_log = Model.get_activity_log!(id)
    {:ok, _} = Model.delete_activity_log(activity_log)

    {:noreply, stream_delete(socket, :activity_logs, activity_log)}
  end
end
