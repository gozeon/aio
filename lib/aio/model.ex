defmodule Aio.Model do
  @moduledoc """
  The Model context.
  """

  import Ecto.Query, warn: false
  alias Aio.Repo
  alias Aio.Scope

  alias Aio.Model.Todo

  def subscribe(%Scope{} = scope) do
    Phoenix.PubSub.subscribe(Aio.PubSub, topic(scope))
  end

  def topic(%Scope{} = scope), do: "todo:#{scope.current_user.id}"

  def broadcast(%Scope{} = scope, event) do
    Phoenix.PubSub.broadcast(Aio.PubSub, topic(scope), {__MODULE__, event})
  end

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos(%Scope{} = scope) do
    Repo.all(from t in Todo, where: t.user_id == ^scope.current_user_id)
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(%Scope{} = scope, id) do
    from(t in Todo, where: t.id == ^id and t.user_id == ^scope.current_user_id)
    |> Repo.one!()
  end

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(%Scope{} = scope, attrs \\ %{}) do
    %Todo{user: scope.current_user}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end
end
