defmodule PAPBackend.PlacesTest do
  use PAPBackend.DataCase

  alias PAPBackend.Places

  describe "locations" do
    alias PAPBackend.Places.Location

    @valid_attrs %{code: "some code", latitude: "some latitude", longitude: "some longitude"}
    @update_attrs %{code: "some updated code", latitude: "some updated latitude", longitude: "some updated longitude"}
    @invalid_attrs %{code: nil, latitude: nil, longitude: nil}

    def location_fixture(attrs \\ %{}) do
      {:ok, location} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Places.create_location()

      location
    end

    test "list_locations/0 returns all locations" do
      location = location_fixture()
      assert Places.list_locations() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert Places.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      assert {:ok, %Location{} = location} = Places.create_location(@valid_attrs)
      assert location.code == "some code"
      assert location.latitude == "some latitude"
      assert location.longitude == "some longitude"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Places.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()
      assert {:ok, location} = Places.update_location(location, @update_attrs)
      assert %Location{} = location
      assert location.code == "some updated code"
      assert location.latitude == "some updated latitude"
      assert location.longitude == "some updated longitude"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = Places.update_location(location, @invalid_attrs)
      assert location == Places.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = Places.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> Places.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = Places.change_location(location)
    end
  end
end
