defmodule GameRoom.Game.TicTacToeTest do
  use ExUnit.Case, async: true

  alias GameRoom.Player
  alias GameRoom.Game
  alias GameRoom.Game.TicTacToe, as: TTT

  setup do
    p1 = %Player{id: 1}
    game = TTT.new(p1)

    [
      p1: p1,
      p2: %Player{id: 2},
      p3: %Player{id: 3},
      game: game
    ]
  end

  test "new player is listed", %{p1: p1} do
    game = TTT.new(p1)

    assert p1 in Game.players(game)
  end

  test "added player is listed", %{p2: p2, game: game} do
    {_, game} = Game.add_player(game, p2)

    assert p2 in Game.players(game)
  end

  test "removed player is not listed", %{p1: p1, p2: p2, game: game} do
    {_, game} = Game.add_player(game, p2)
    game = Game.remove_player(game, p1)

    refute p1 in Game.players(game)
  end

  # TODO(adam): add custom impl for test purposes
  # test "fullness status", %{p2: p2, game: game} do
  #   assert {:open, _} = Game.add_player(game, p2)
  #   assert {:full, _} = Game.add_player(game, p3)
  # end

  test "no players returns empty", %{p1: p1, p2: p2, game: game} do
    {_, game} = Game.add_player(game, p2)
    game = game |> Game.remove_player(p1) |> Game.remove_player(p2)

    assert game == :empty
  end

  test "cannot add the same player twice", %{p1: p1, game: game} do
    assert_raise CaseClauseError, fn -> Game.add_player(game, p1) end
  end

  test "cannot add a third player", %{p2: p2, p3: p3, game: game} do
    {_, game} = Game.add_player(game, p2)

    assert_raise CaseClauseError, fn -> Game.add_player(game, p3) end
  end
end
