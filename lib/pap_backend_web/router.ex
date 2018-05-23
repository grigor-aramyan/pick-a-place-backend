defmodule PAPBackendWeb.Router do
  use PAPBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_auth do
    plug :ensure_authenticated
  end

  scope "/api", PAPBackendWeb do
    pipe_through :api

    resources "/locations", LocationController, only: [:create, :show]
    resources "/users", UserController, only: [:create, :show]

    post "/users/sign_in", UserController, :sign_in
    post "/locations/get_location", LocationController, :get_location
    post "/locations/get_live_location", LocationController, :get_live_location
    post "/locations/live", LocationController, :create_live_anonymous
  end

  scope "/api", PAPBackendWeb do
    pipe_through [:api, :api_auth]

    post "/users/sign_out", UserController, :sign_out
    post "/locations/get_locations_by_user_id", LocationController, :get_locations_by_user_id
  end

  defp ensure_authenticated(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> render(PAPBackendWeb.ErrorView, "401.json", message: "Unauthenticated user")
      |> halt()
    end
  end
end
