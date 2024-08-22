defmodule Aio.Model.ActivityLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activity_logs" do
    field :meta, :string
    field :action, :string
    field :subject, :string
    belongs_to :user, Aio.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(activity_log, attrs) do
    activity_log
    |> cast(attrs, [:meta, :action, :subject])
    |> validate_required([:action, :subject])
  end
end
