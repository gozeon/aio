defmodule Aio.ModelTest do
  use Aio.DataCase

  alias Aio.Model

  describe "todos" do
    alias Aio.Model.Todo

    import Aio.ModelFixtures

    @invalid_attrs %{status: nil, title: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Model.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Model.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{status: :todo, title: "some title"}

      assert {:ok, %Todo{} = todo} = Model.create_todo(valid_attrs)
      assert todo.status == :todo
      assert todo.title == "some title"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{status: :doing, title: "some updated title"}

      assert {:ok, %Todo{} = todo} = Model.update_todo(todo, update_attrs)
      assert todo.status == :doing
      assert todo.title == "some updated title"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_todo(todo, @invalid_attrs)
      assert todo == Model.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Model.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Model.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Model.change_todo(todo)
    end
  end

  describe "activity_logs" do
    alias Aio.Model.ActivityLog

    import Aio.ModelFixtures

    @invalid_attrs %{meta: nil, user: nil, action: nil, subject: nil}

    test "list_activity_logs/0 returns all activity_logs" do
      activity_log = activity_log_fixture()
      assert Model.list_activity_logs() == [activity_log]
    end

    test "get_activity_log!/1 returns the activity_log with given id" do
      activity_log = activity_log_fixture()
      assert Model.get_activity_log!(activity_log.id) == activity_log
    end

    test "create_activity_log/1 with valid data creates a activity_log" do
      valid_attrs = %{
        meta: %{},
        user: "some user",
        action: "some action",
        subject: "some subject"
      }

      assert {:ok, %ActivityLog{} = activity_log} = Model.create_activity_log(valid_attrs)
      assert activity_log.meta == %{}
      assert activity_log.user == "some user"
      assert activity_log.action == "some action"
      assert activity_log.subject == "some subject"
    end

    test "create_activity_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_activity_log(@invalid_attrs)
    end

    test "update_activity_log/2 with valid data updates the activity_log" do
      activity_log = activity_log_fixture()

      update_attrs = %{
        meta: %{},
        user: "some updated user",
        action: "some updated action",
        subject: "some updated subject"
      }

      assert {:ok, %ActivityLog{} = activity_log} =
               Model.update_activity_log(activity_log, update_attrs)

      assert activity_log.meta == %{}
      assert activity_log.user == "some updated user"
      assert activity_log.action == "some updated action"
      assert activity_log.subject == "some updated subject"
    end

    test "update_activity_log/2 with invalid data returns error changeset" do
      activity_log = activity_log_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_activity_log(activity_log, @invalid_attrs)
      assert activity_log == Model.get_activity_log!(activity_log.id)
    end

    test "delete_activity_log/1 deletes the activity_log" do
      activity_log = activity_log_fixture()
      assert {:ok, %ActivityLog{}} = Model.delete_activity_log(activity_log)
      assert_raise Ecto.NoResultsError, fn -> Model.get_activity_log!(activity_log.id) end
    end

    test "change_activity_log/1 returns a activity_log changeset" do
      activity_log = activity_log_fixture()
      assert %Ecto.Changeset{} = Model.change_activity_log(activity_log)
    end
  end
end
