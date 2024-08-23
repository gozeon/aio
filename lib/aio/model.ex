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

  alias Aio.Model.ActivityLog

  @doc """
  Returns the list of activity_logs.

  ## Examples

      iex> list_activity_logs()
      [%ActivityLog{}, ...]

  """
  def list_activity_logs do
    Repo.all(ActivityLog) |> Repo.preload(:user)
  end

  def get_activity_logs_latest do
    Repo.all(from t in ActivityLog, limit: 5, order_by: [desc: t.inserted_at])
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single activity_log.

  Raises `Ecto.NoResultsError` if the Activity log does not exist.

  ## Examples

      iex> get_activity_log!(123)
      %ActivityLog{}

      iex> get_activity_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity_log!(id), do: Repo.get!(ActivityLog, id) |> Repo.preload(:user)

  @doc """
  Creates a activity_log.

  ## Examples

      iex> create_activity_log(%{field: value})
      {:ok, %ActivityLog{}}

      iex> create_activity_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity_log(%Scope{} = scope, attrs \\ %{}) do
    %ActivityLog{user: scope.current_user}
    |> ActivityLog.changeset(attrs)
    |> ActivityLog.set_meta(%{"create_user" => scope.current_user.email})
    |> Repo.insert()
  end

  @doc """
  Updates a activity_log.

  ## Examples

      iex> update_activity_log(activity_log, %{field: new_value})
      {:ok, %ActivityLog{}}

      iex> update_activity_log(activity_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity_log(%Scope{} = scope, %ActivityLog{} = activity_log, attrs) do
    activity_log
    |> ActivityLog.changeset(attrs)
    |> ActivityLog.set_meta(%{"update_user" => scope.current_user.email})
    |> Repo.update()
  end

  @doc """
  Deletes a activity_log.

  ## Examples

      iex> delete_activity_log(activity_log)
      {:ok, %ActivityLog{}}

      iex> delete_activity_log(activity_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity_log(%ActivityLog{} = activity_log) do
    Repo.delete(activity_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity_log changes.

  ## Examples

      iex> change_activity_log(activity_log)
      %Ecto.Changeset{data: %ActivityLog{}}

  """
  def change_activity_log(%ActivityLog{} = activity_log, attrs \\ %{}) do
    ActivityLog.changeset(activity_log, attrs)
  end
end
