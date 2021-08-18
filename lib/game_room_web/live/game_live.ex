defmodule GameRoomWeb.GameLive do
  use GameRoomWeb, :live_view

  @impl true
  def mount(%{"id" => id, "game" => slug}, session, socket) do
    socket = assign_defaults(session, socket)
    socket = assign(socket, id: id, slug: slug, game_module: slug_to_module(slug))

    {:ok, socket}
  end

  def slug_to_module(slug) do
    :persistent_term.get(:slug_mapping) |> Map.fetch!(slug)
  end
end
