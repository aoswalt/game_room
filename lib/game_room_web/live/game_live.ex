defmodule GameRoomWeb.GameLive do
  use GameRoomWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)}
  end
end
