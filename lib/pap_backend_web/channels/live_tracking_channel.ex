defmodule PAPBackendWeb.LiveTrackingChannel do
  use PAPBackendWeb, :channel

  alias PAPBackend.Places
  alias PAPBackend.Places.Location
  alias Ecto.Changeset
  alias PAPBackend.Repo

  def join("live_tracking:general", _params, socket) do
    {:ok, socket}
  end

  def handle_in("live_tracking:update_live_location", params, socket) do
    code = params["code"]
    longitude = params["longitude"]
    latitude = params["latitude"]

    location = Repo.get_by(Location, code: code)
    location = Changeset.change(location, latitude: latitude)
    location = Changeset.change(location, longitude: longitude)

    case Repo.update location do
      {:ok, _l} ->
        broadcast! socket, "live_tracking:get_live_location", %{
          code: code,
          longitude: longitude,
          latitude: latitude
        }
      {:error, _changeset} ->
        push socket, "live_tracking:update_live_location", %{
          error: "error updating data"
        }
    end

    {:reply, :ok, socket}
  end

  def handle_in("live_tracking:delete_live_location", params, socket) do
    code = params["code"]

    location = Repo.get_by!(Location, code: code)
    case Places.delete_location(location) do
      {:ok, _location} ->
        broadcast socket, "live_tracking:delete_live_location", %{
          code: code,
          msg: "Record deleted"
        }
      {:error, _changeset} ->
        broadcast socket, "live_tracking:delete_live_location", %{
          code: code,
          error: "Error deleting record"
        }
    end

    {:reply, :ok, socket}
  end
end