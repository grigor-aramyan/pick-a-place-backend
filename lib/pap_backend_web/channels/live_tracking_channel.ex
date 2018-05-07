defmodule PAPBackendWeb.LiveTrackingChannel do
  use PAPBackendWeb, :channel

  def join("live_tracking:general", _params, socket) do
    {:ok, socket}
  end
end