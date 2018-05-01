defmodule PAPBackend.Repo.Migrations.AddUsersForeignKeyToLocation do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      add :user_id, references(:users, on_delete: :nothing), null: true
    end
  end
end
