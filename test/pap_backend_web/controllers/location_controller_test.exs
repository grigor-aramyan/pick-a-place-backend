defmodule PAPBackendWeb.LocationControllerTest do
  use PAPBackendWeb.ConnCase

  alias PAPBackend.Places
  alias PAPBackend.Places.Location

  @create_attrs %{code: "some code", latitude: "some latitude", longitude: "some longitude"}
  @update_attrs %{code: "some updated code", latitude: "some updated latitude", longitude: "some updated longitude"}
  @invalid_attrs %{code: nil, latitude: nil, longitude: nil}

  def fixture(:location) do
    {:ok, location} = Places.create_location(@create_attrs)
    location
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all locations", %{conn: conn} do
      conn = get conn, location_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create location" do
    test "renders location when data is valid", %{conn: conn} do
      conn = post conn, location_path(conn, :create), location: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, location_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "code" => "some code",
        "latitude" => "some latitude",
        "longitude" => "some longitude"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, location_path(conn, :create), location: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update location" do
    setup [:create_location]

    test "renders location when data is valid", %{conn: conn, location: %Location{id: id} = location} do
      conn = put conn, location_path(conn, :update, location), location: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, location_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "code" => "some updated code",
        "latitude" => "some updated latitude",
        "longitude" => "some updated longitude"}
    end

    test "renders errors when data is invalid", %{conn: conn, location: location} do
      conn = put conn, location_path(conn, :update, location), location: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete location" do
    setup [:create_location]

    test "deletes chosen location", %{conn: conn, location: location} do
      conn = delete conn, location_path(conn, :delete, location)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, location_path(conn, :show, location)
      end
    end
  end

  defp create_location(_) do
    location = fixture(:location)
    {:ok, location: location}
  end
end
