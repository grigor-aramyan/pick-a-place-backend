defmodule PAPBackend.Places do
  @moduledoc """
  The Places context.
  """

  import Ecto.Query, warn: false
  alias PAPBackend.Repo

  alias PAPBackend.Places.Location

  @doc """
  Returns the list of locations.

  ## Examples

      iex> list_locations()
      [%Location{}, ...]

  """
  def list_locations do
    Repo.all(Location)
  end

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location!(id), do: Repo.get!(Location, id)

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{source: %Location{}}

  """
  def change_location(%Location{} = location) do
    Location.changeset(location, %{})
  end

  def get_locations_by_user_id(user_id) do
    query = from l in "locations",
      where: l.user_id == ^user_id,
      select: [l.id, l.code, l.longitude, l.latitude, l.message, l.live]

      list_of_lists = Repo.all(query)
      turn_map(list_of_lists)
  end

  defp turn_map([]) do
    []
  end
  defp turn_map([head | tail]) do
    [ %Location{id: Enum.at(head, 0), code: Enum.at(head, 1), longitude: Enum.at(head, 2), latitude: Enum.at(head, 3),
      message: Enum.at(head, 4), live: Enum.at(head, 5)} ] ++ turn_map(tail)
  end
end
