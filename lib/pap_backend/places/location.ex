defmodule PAPBackend.Places.Location do
  use Ecto.Schema
  import Ecto.Changeset


  schema "locations" do
    field :code, :string
    field :latitude, :string
    field :longitude, :string

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:code, :latitude, :longitude])
    |> validate_required([:code, :latitude, :longitude])
  end
end
