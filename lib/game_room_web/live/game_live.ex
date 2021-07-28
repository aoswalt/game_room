defmodule GameRoomWeb.GameLive do
  use GameRoomWeb, :live_view

  @impl true
  def mount(%{"id" => id}, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok, assign(socket, :id, id)}
  end
end
