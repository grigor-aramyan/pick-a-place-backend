defmodule PAPBackendWeb.LocationController do
  use PAPBackendWeb, :controller

  import Ecto.Query, only: [from: 2]

  alias PAPBackend.Places
  alias PAPBackend.Places.Location
  alias PAPBackend.Repo

  action_fallback PAPBackendWeb.FallbackController

  def index(conn, _params) do
    locations = Places.list_locations()
    render(conn, "index.json", locations: locations)
  end

  def create(conn, %{"location" => location_params}) do
    code =
      :crypto.strong_rand_bytes(24)
      |> Base.url_encode64
      |> binary_part(0, 8)

    location_params_extended = Map.put(location_params, "code", code)

    with {:ok, %Location{} = location} <- Places.create_location(location_params_extended) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", location_path(conn, :show, location))
      |> render("show.json", location: location)
    end
  end

  def show(conn, %{"id" => id}) do
    location = Places.get_location!(id)
    render(conn, "show.json", location: location)
  end

  def update(conn, %{"id" => id, "location" => location_params}) do
    location = Places.get_location!(id)

    with {:ok, %Location{} = location} <- Places.update_location(location, location_params) do
      render(conn, "show.json", location: location)
    end
  end

  def delete(conn, %{"id" => id}) do
    location = Places.get_location!(id)
    with {:ok, %Location{}} <- Places.delete_location(location) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_live_location(conn, %{"code" => code}) do
    query = from l in "locations",
            where: l.code == ^code and l.live == true,
            select: l.id
    id_list = Repo.all(query)
    [ first_id | rest ] = id_list

    location = Repo.get(Location, first_id)
    if location do
      render(conn, "show.json", location: location)
    else
      render(conn, PAPBackendWeb.ErrorView, "401.json", message: "Non-existent code")
    end
  end
  def get_live_location(conn, _params) do
    render(conn, PAPBackendWeb.ErrorView, "401.json", message: "Non-existent code")
  end

  def get_location(conn, %{"code" => code}) do
    location = Repo.get_by(Location, code: code)

    if location do
      render(conn, "show.json", location: location)
    else
      render(conn, PAPBackendWeb.ErrorView, "401.json", message: "Non-existent code")
    end
  end

  def get_location(conn, _params) do
    render(conn, PAPBackendWeb.ErrorView, "401.json", message: "Non-existent code")
  end
end
