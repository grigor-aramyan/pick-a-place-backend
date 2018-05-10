defmodule PAPBackend.Places.Location do
  use Ecto.Schema
  import Ecto.Changeset

  alias PAPBackend.Accounts.User

  schema "locations" do
    field :code, :string
    field :latitude, :string
    field :longitude, :string
    field :message, :string
    field :live, :boolean
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:code, :latitude, :longitude, :message, :live, :user_id])
    |> validate_required([:code, :latitude, :longitude])
  end
end
