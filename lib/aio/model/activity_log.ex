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

  def format_meta(meta) when byte_size(meta) > 0 do
    case Jason.decode(meta) do
      {:ok, mmeta} when is_map(mmeta) ->
        mmeta

      _ ->
        %{"old" => meta}
    end
  end

  def format_meta(_meta) do
    %{}
  end

  def get_meta?(changeset) do
    if changeset.data.id do
      # Logic for updates
      format_meta(changeset.data.meta)
    else
      # Logic for inserts
      format_meta(get_change(changeset, :meta))
    end
  end

  def set_meta(changeset, meta \\ %{}) do
    put_change(changeset, :meta, Jason.encode!(Map.merge(get_meta?(changeset), meta)))
  end
end
