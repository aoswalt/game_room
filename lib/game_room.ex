defmodule GameRoom do
  @moduledoc """
  GameRoom keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def list_lobby_games(get_player_counts \\ &GameRoom.Games.list_player_counts/0) do
    modules = list_game_modules()
    # TODO(adam): need to be distinct on game type because of registry entry per player
    games = get_player_counts.()

    Enum.map(
      modules,
      &%{display_name: &1.display_name, player_count: games[&1] || 0, module_name: &1}
    )
  end

  def list_game_modules() do
    Application.fetch_env!(:game_room, :game_modules)
  end
end

# 2 pages: lobby & game
# lobby: list of games
# game: canvas or html/divs
# player: just id?

# game: logic & protocol
# room genserver: game data state & interaction
