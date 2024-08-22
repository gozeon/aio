defmodule Aio.Repo.Migrations.UpdateActivityLogsUser do
  use Ecto.Migration

  def change do
    alter table(:activity_logs) do
      remove :user
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
