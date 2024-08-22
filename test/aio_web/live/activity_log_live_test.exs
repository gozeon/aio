defmodule AioWeb.ActivityLogLiveTest do
  use AioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Aio.ModelFixtures

  @create_attrs %{meta: %{}, user: "some user", action: "some action", subject: "some subject"}
  @update_attrs %{
    meta: %{},
    user: "some updated user",
    action: "some updated action",
    subject: "some updated subject"
  }
  @invalid_attrs %{meta: nil, user: nil, action: nil, subject: nil}

  defp create_activity_log(_) do
    activity_log = activity_log_fixture()
    %{activity_log: activity_log}
  end

  describe "Index" do
    setup [:create_activity_log]

    test "lists all activity_logs", %{conn: conn, activity_log: activity_log} do
      {:ok, _index_live, html} = live(conn, ~p"/activity_logs")

      assert html =~ "Listing Activity logs"
      assert html =~ activity_log.user
    end

    test "saves new activity_log", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/activity_logs")

      assert index_live |> element("a", "New Activity log") |> render_click() =~
               "New Activity log"

      assert_patch(index_live, ~p"/activity_logs/new")

      assert index_live
             |> form("#activity_log-form", activity_log: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#activity_log-form", activity_log: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/activity_logs")

      html = render(index_live)
      assert html =~ "Activity log created successfully"
      assert html =~ "some user"
    end

    test "updates activity_log in listing", %{conn: conn, activity_log: activity_log} do
      {:ok, index_live, _html} = live(conn, ~p"/activity_logs")

      assert index_live
             |> element("#activity_logs-#{activity_log.id} a", "Edit")
             |> render_click() =~
               "Edit Activity log"

      assert_patch(index_live, ~p"/activity_logs/#{activity_log}/edit")

      assert index_live
             |> form("#activity_log-form", activity_log: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#activity_log-form", activity_log: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/activity_logs")

      html = render(index_live)
      assert html =~ "Activity log updated successfully"
      assert html =~ "some updated user"
    end

    test "deletes activity_log in listing", %{conn: conn, activity_log: activity_log} do
      {:ok, index_live, _html} = live(conn, ~p"/activity_logs")

      assert index_live
             |> element("#activity_logs-#{activity_log.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#activity_logs-#{activity_log.id}")
    end
  end

  describe "Show" do
    setup [:create_activity_log]

    test "displays activity_log", %{conn: conn, activity_log: activity_log} do
      {:ok, _show_live, html} = live(conn, ~p"/activity_logs/#{activity_log}")

      assert html =~ "Show Activity log"
      assert html =~ activity_log.user
    end

    test "updates activity_log within modal", %{conn: conn, activity_log: activity_log} do
      {:ok, show_live, _html} = live(conn, ~p"/activity_logs/#{activity_log}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Activity log"

      assert_patch(show_live, ~p"/activity_logs/#{activity_log}/show/edit")

      assert show_live
             |> form("#activity_log-form", activity_log: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#activity_log-form", activity_log: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/activity_logs/#{activity_log}")

      html = render(show_live)
      assert html =~ "Activity log updated successfully"
      assert html =~ "some updated user"
    end
  end
end
