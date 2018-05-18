defmodule PAPBackend.Workers.RecordCleaningScheduler do
  use GenServer

  import Ecto.Query, only: [from: 2]

  alias PAPBackend.Repo
  alias PAPBackend.Places
  alias PAPBackend.Places.Location

  def start_link() do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do

    query = from l in "locations",
        where: l.live == false,
        select: [l.id, l.updated_at]
    result = Repo.all(query)
    compare_times_and_delete(result)

    schedule_work()
    {:noreply, state}
  end

  defp compare_times_and_delete([]) do

  end
  defp compare_times_and_delete([head | tail]) do
    [id | time_list] = head

    [time|_empty] = time_list

    diff = NaiveDateTime.diff(Timex.to_naive_datetime(Timex.now), Timex.to_naive_datetime(time))

    if diff > 8 * 60 * 60 do
      l = Repo.get(Location, id)
      Places.delete_location(l)
    end
    compare_times_and_delete(tail)
  end
  
  defp schedule_work() do
    Process.send_after(self(), :work, 1000 * 60 * 60 * 8)
  end
end