defmodule PAPBackend.Auth do
  import Ecto.Query, only: [from: 2]

  alias PAPBackend.Repo
  alias PAPBackend.Accounts.User

  def authenticate_user(email, password) do
    query = from u in User, where: u.email == ^email
    query |> Repo.one() |> verify_password(password)
  end

  defp verify_password(nil, _) do
    # Perform a dummy check to make user enumeration more difficult
    Bcrypt.no_user_verify()
    {:error, "Wrong email or password"}
  end

  defp verify_password(user, password) do
    if Bcrypt.verify_pass(password, user.password) do
      {:ok, user}
    else
      {:error, "Wrong email or password"}
    end
  end
end