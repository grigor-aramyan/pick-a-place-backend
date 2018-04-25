defmodule PAPBackendWeb.Router do
  use PAPBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PAPBackendWeb do
    pipe_through :api
  end
end
