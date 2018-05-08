defmodule PAPBackend.Repo.Migrations.AddLiveFieldToLocationSchema do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      add :live, :boolean, default: false
    end
  end
end
