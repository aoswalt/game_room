defmodule GameRoom.GameInstance do
  use GenServer

  alias GameRoom.Game

  def start(game_type, player, game_id \\ :rand.uniform(1000)) do
    game = game_type.new(player)

    key = {game_type, game_id}
    via = {GameRegistry, key, :open}
    name = {:via, Registry, via}
    GenServer.start(__MODULE__, {key, game}, name: name)
  end

  @impl true
  def init(state) do

    {:ok, state}
  end

  @impl true
  def handle_call(:players, _, {_, game} = state) do
    {:reply, Game.players(game), state}
  end

  @impl true
  def handle_call(:player_count, _, {_, game} = state) do
    {:reply, Game.players(game) |> length(), state}
  end

  @impl true
  def handle_call({:add_player, player}, _, {key, game}) do
    {status, game} = GameRoom.Game.add_player(game, player)
    Registry.update_value(GameRegistry, key, fn _ -> status end)
    {:reply, game, {key, game}}
  end
end
