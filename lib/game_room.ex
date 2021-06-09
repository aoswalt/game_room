defmodule GameRoom.Player do
  defstruct [:id]
end

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

      # Enum.flat_map(impls, & &1.values(all?: true))
    end
  end
end

# 2 pages: lobby & game
# lobby: list of games
# game: canvas or html/divs
# player: just id?

# game: logic & protocol
# room genserver: game data state & interaction

defprotocol GameRoom.Game do
  alias GameRoom.Player

  @spec add_player(t(), Player.t()) :: t()
  def add_player(game, player)

  @spec remove_player(t(), Player.t()) :: t() | :empty
  def remove_player(game, player)

  @spec players(t()) :: [Player.t()]
  def players(game)

  @spec take_action(t(), Player.t(), action :: term()) :: t()
  def take_action(game, player, action)
end

defmodule GameRoom.NewGame do
  alias GameRoom.Game
  alias GameRoom.Player

  @doc """
  Create a new instance of a game, given a player.
  """
  @callback new(Player.t()) :: Game.t()

  @doc """
  Get the UI-friendly display name for a game.
  """
  @callback display_name() :: String.t()
end

defmodule GameRoom.Game.TicTacToe do
  alias __MODULE__
  alias GameRoom.Player

  @behaviour GameRoom.NewGame

  @board {
    {nil, nil, nil},
    {nil, nil, nil},
    {nil, nil, nil}
  }

  defstruct [:x, :o, board: @board]

  @impl GameRoom.NewGame
  def new(%Player{} = p), do: %TicTacToe{x: p}

  @impl GameRoom.NewGame
  def display_name(), do: "Tic Tac Toe"

  @doc false
  # draw?
  def victor(%{board: board}) do
    case board do
      {{p, p, p}, _, _} ->
        p

      {_, {p, p, p}, _} ->
        p

      {_, _, {p, p, p}} ->
        p

      {{p, _, _}, {p, _, _}, {p, _, _}} ->
        p

      {{_, p, _}, {_, p, _}, {_, p, _}} ->
        p

      {{_, _, p}, {_, _, p}, {_, _, p}} ->
        p

      {{p, _, _}, {_, p, _}, {_, _, p}} ->
        p

      {{_, _, p}, {_, p, _}, {p, _, _}} ->
        p

      _ ->
        nil
        # draw?
    end
  end

  defimpl GameRoom.Game do
    def add_player(%TicTacToe{} = game, %Player{} = p) do
      case game do
        %{x: nil, o: o} = game when not is_nil(o) and o != p -> %{game | x: p}
        %{x: x, o: nil} = game when not is_nil(x) and x != p -> %{game | o: p}
      end
    end

    def remove_player(%TicTacToe{} = game, %Player{} = p) do
      case game do
        %{x: ^p, o: nil} -> :empty
        %{x: ^p, o: _} = game -> %{game | x: nil}
        %{x: nil, o: ^p} -> :empty
        %{x: _, o: ^p} = game -> %{game | o: nil}
      end
    end

    # return fullness?
    def players(%TicTacToe{x: x, o: o}) do
      Enum.reject([x, o], &is_nil/1)
    end

    # :rematch
    def take_action(%TicTacToe{} = game, %Player{} = p, {x, y}) when x in 0..2 and y in 0..2 do
      player_piece =
        case game do
          %{x: ^p} -> :x
          %{o: ^p} -> :o
        end

      existing_piece = game.board |> elem(y) |> elem(x)

      case existing_piece do
        nil ->
          new_row = game.board |> elem(y) |> put_elem(x, player_piece)
          %{game | board: put_elem(game.board, y, new_row)}

        _ ->
          game
      end
    end
  end
end
