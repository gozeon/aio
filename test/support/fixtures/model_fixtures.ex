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

  @doc """
  Generate a activity_log.
  """
  def activity_log_fixture(attrs \\ %{}) do
    {:ok, activity_log} =
      attrs
      |> Enum.into(%{
        action: "some action",
        meta: %{},
        subject: "some subject",
        user: "some user"
      })
      |> Aio.Model.create_activity_log()

    activity_log
  end
end
