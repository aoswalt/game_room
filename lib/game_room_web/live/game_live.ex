defmodule GameRoomWeb.GameLive do
  use GameRoomWeb, :live_view

  @impl true
  def mount(%{"id" => id, "game" => slug}, session, socket) do
    id = String.to_integer(id)

    socket = assign_defaults(session, socket)
    game_module = slug_to_module(slug)

    game = GameRoom.Games.get_game(game_module, id)

    socket = assign(socket, id: id, slug: slug, game_module: game_module, game_pid: game)

    {:ok, socket}
  end

  def slug_to_module(slug) do
    :persistent_term.get(:slug_mapping) |> Map.fetch!(slug)
  end
end
