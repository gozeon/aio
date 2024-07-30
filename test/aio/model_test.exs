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
end
