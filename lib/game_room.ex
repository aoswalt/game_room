defmodule GameRoom do
  @moduledoc """
  GameRoom keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
end

# 2 pages: lobby & game
# lobby: list of games
# game: canvas or html/divs
# player: just id?

# game: logic & protocol
# room genserver: game data state & interaction

defmodule GameRoom.Player do
  defstruct [:id]
end

defprotocol GameRoom.Game do
  alias GameRoom.Player

  @doc """
  Create a new instance of a game, given a player.
  """
  @spec new(Player.t()) :: t()
  def new(player)

  @spec add_player(t(), Player.t()) :: t()
  def add_player(game, player)

  @spec remove_player(t(), Player.t()) :: t()
  def remove_player(game, player)

  # def players(game)

  @spec take_action(t(), Player.t(), action :: term()) :: t()
  def take_action(game, player, action)
end

defmodule GameRoom.Game.TicTacToe do
  # alias __MODULE__
  # alias GameRoom.Player

  @board {
    {nil, nil, nil},
    {nil, nil, nil},
    {nil, nil, nil},
  }

  defstruct [board: @board]

  @doc false
  def victor(%{board: board}) do
    case board do
      {{p, p, p}, _, _} -> p
      {_, {p, p, p}, _} -> p
      {_, _, {p, p, p}} -> p
      {{p, _, _}, {p, _, _}, {p, _, _}} -> p
      {{_, p, _}, {_, p, _}, {_, p, _}} -> p
      {{_, _, p}, {_, _, p}, {_, _, p}} -> p
      {{p, _, _}, {_, p, _}, {_, _, p}} -> p
      {{_, _, p}, {_, p, _}, {p, _, _}} -> p
      _ -> nil
    end
  end

  defimpl GameRoom.Game do
    # fill in
  end
end
