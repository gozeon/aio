defmodule Aio.ModelFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Aio.Model` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        status: :todo,
        title: "some title"
      })
      |> Aio.Model.create_todo()

    todo
  end
end
