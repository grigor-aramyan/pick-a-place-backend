defmodule PAPBackend.Places.Location do
  use Ecto.Schema
  import Ecto.Changeset

  alias PAPBackend.Accounts.User

  schema "locations" do
    field :code, :string
    field :latitude, :string
    field :longitude, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:code, :latitude, :longitude])
    |> validate_required([:code, :latitude, :longitude])
  end
end
