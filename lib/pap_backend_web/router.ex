defmodule PAPBackendWeb.Router do
  use PAPBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PAPBackendWeb do
    pipe_through :api

    resources "/locations", LocationController, only: [:create, :show]
    resources "/users", UserController, only: [:create, :show]
  end
end
