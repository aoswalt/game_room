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
