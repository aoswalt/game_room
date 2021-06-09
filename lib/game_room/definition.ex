defmodule GameRoom.Definition do
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
