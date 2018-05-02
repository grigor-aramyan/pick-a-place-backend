defmodule PAPBackendWeb.UserController do
  use PAPBackendWeb, :controller

  alias PAPBackend.Repo

  alias PAPBackend.Accounts
  alias PAPBackend.Accounts.User
  alias PAPBackend.Auth

  action_fallback PAPBackendWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("user", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_status(:ok)
        |> render(PAPBackendWeb.UserView, "sign_in.json", user: user)

      {:error, message} ->
        conn
        |> delete_session(:current_user_id)
        |> put_status(:unauthorized)
        |> render(PAPBackendWeb.ErrorView, "401.json", message: message)
    end
  end

  def sign_out(conn, _params) do
    current_user_id = get_session(conn, :current_user_id)
    user = Repo.get!(User, current_user_id)

    conn
    |> delete_session(:current_user_id)
    |> put_status(:ok)
    |> render(PAPBackendWeb.UserView, "sign_out.json", user: user)
  end
end