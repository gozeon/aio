defmodule AioWeb.ActivityLogComponents do
  use AioWeb, :live_component

  alias Aio.Model

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>Activity Log</.header>
      <.list>
        <:item :for={item <- @logs} title={time_ago(item.inserted_at)}>
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

  def time_ago(datetime) do
    now = DateTime.utc_now()
    difference = DateTime.diff(now, datetime, :second)

    cond do
      difference < 60 ->
        "now"
      difference < 3600 ->
        "#{div(difference, 60)} minutes ago"
      difference < 86400 ->
        "#{div(difference, 3600)} hours ago"
      difference < 604800 ->
        "#{div(difference, 86400)} days ago"
      true ->
        format_date(datetime)
    end
  end

  defp format_date(datetime) do
    datetime
    |> Calendar.strftime("%c")
  end
end
