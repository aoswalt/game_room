defmodule GameRoom do
  @moduledoc """
  GameRoom keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def list_lobby_games(get_player_counts \\ &GameRoom.Games.list_player_counts/0) do
    modules = list_game_modules()
    games = get_player_counts.()

    Enum.map(
      modules,
      &%{display_name: &1.display_name, player_count: games[&1] || 0, module_name: &1}
    )
  end

  if Mix.env() == :dev do
    # NOTE(adam): Phoneix CodeReloader nukes protocols when reloading, so workaround
    def list_game_modules() do
      {:ok, modules} = :application.get_key(:game_room, :modules)

      modules
      |> Enum.map(&Atom.to_string/1)
      |> Enum.filter(&(&1 =~ ~r/Elixir\.GameRoom\.Game\.\w+$/))
      |> Enum.map(&String.to_existing_atom/1)
    end
  else
    def list_game_modules() do
      {:consolidated, impls} = GameRoom.Game.__protocol__(:impls)

      impls
    end
  end
end

# 2 pages: lobby & game
# lobby: list of games
# game: canvas or html/divs
# player: just id?

# game: logic & protocol
# room genserver: game data state & interaction
