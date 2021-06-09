defmodule GameRoom do
  @moduledoc """
  GameRoom keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def storage() do
    alias GameRoom.Game.TicTacToe, as: TTT
    alias GameRoom.Player, as: P

    %{
      1 => TTT.new(%P{id: 1}),
      2 => TTT.new(%P{id: 2}) |> GameRoom.Game.add_player(%P{id: 3}),
      3 => TTT.new(%P{id: 4}) |> GameRoom.Game.add_player(%P{id: 5}),
      4 => TTT.new(%P{id: 6})
    }
  end

  def list_lobby_games(get_storage \\ &storage/0) do
    modules = list_game_modules()
    games = get_storage.() |> Map.values() |> Enum.group_by(& &1.__struct__)

    player_count = fn mod ->
      games |> Map.get(mod, []) |> Enum.flat_map(&GameRoom.Game.players/1) |> length()
    end

    Enum.map(
      modules,
      &%{display_name: &1.display_name, player_count: player_count.(&1), module_name: &1}
    )
  end

  if Mix.env() == :dev do
    # NOTE(adam): Phoneix CodeReloader nukes protocols when reloading, so workaround
    def list_game_modules() do
      {:ok, modules} = :application.get_key(:game_room, :modules)

      modules
      |> Enum.map(&Atom.to_string/1)
      |> Enum.filter(&(&1 =~ ~r/Elixir.GameRoom.Game.\w+$/))
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
