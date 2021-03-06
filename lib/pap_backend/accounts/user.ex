defmodule PAPBackend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias PAPBackend.Places.Location

  schema "users" do
    field :email, :string
    field :password, :string
    has_many :locations, Location

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> hash_user_password()
  end

  defp hash_user_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp hash_user_password(changeset) do
    changeset
  end


end
