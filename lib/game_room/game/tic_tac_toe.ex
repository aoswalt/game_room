defmodule GameRoom.Game.TicTacToe do
  alias __MODULE__
  alias GameRoom.Player

  @behaviour GameRoom.Definition

  @board {
    {nil, nil, nil},
    {nil, nil, nil},
    {nil, nil, nil}
  }

  defstruct [:x, :o, board: @board]

  @impl GameRoom.Definition
  def new(%Player{} = p), do: %TicTacToe{x: p}

  @impl GameRoom.Definition
  def display_name(), do: "Tic Tac Toe"

  @impl GameRoom.Definition
  def slug(), do: "tic_tac_toe"

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
      game =
        case game do
          %{x: nil, o: o} = game when not is_nil(o) and o != p -> %{game | x: p}
          %{x: x, o: nil} = game when not is_nil(x) and x != p -> %{game | o: p}
          _ -> raise "Game is already full"
        end

      {:full, game}
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
