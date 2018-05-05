defmodule PAPBackend.Repo.Migrations.AddMessageToLocation do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      add :message, :string, null: true
    end
  end
end
