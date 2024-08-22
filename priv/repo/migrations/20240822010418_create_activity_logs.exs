defmodule Aio.Repo.Migrations.CreateActivityLogs do
  use Ecto.Migration

  def change do
    create table(:activity_logs) do
      add :meta, :string
      add :action, :string
      add :subject, :string
      add :user, :string

      timestamps(type: :utc_datetime)
    end
  end
end
