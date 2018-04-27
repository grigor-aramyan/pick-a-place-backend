defmodule PAPBackend.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :code, :string
      add :latitude, :string
      add :longitude, :string

      timestamps()
    end

  end
end
