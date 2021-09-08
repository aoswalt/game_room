defmodule GameRoom.GameInstance do
  use GenServer

  alias GameRoom.Game

  def start(game_type, player, game_id \\ :rand.uniform(1000)) do
    game = game_type.new(player)

    key = {game_type, game_id, player}
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
  def handle_call({:add_player, player}, _, {{game_type, game_id, _}, game}) do
    {status, game} = GameRoom.Game.add_player(game, player)

    for {key, _pid, _value} <- GameRoom.Games.list_game_instance_entries(game_type, game_id) do
      Registry.update_value(GameRegistry, key, fn _ -> status end)
    end

    key = {game_type, game_id, player}
    Registry.register(GameRegistry, key, status)
    {:reply, game, {key, game}}
  end

  @impl true
  def handle_call(:id, _, {{_module, id, _}, _game} = state) do
    {:reply, id, state}
  end
end
