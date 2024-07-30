defmodule Aio.Model.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :status, Ecto.Enum, values: [:todo, :doing, :done, :end]
    field :title, :string
    belongs_to :user, Aio.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :status])
    |> validate_required([:title, :status])
  end
end
