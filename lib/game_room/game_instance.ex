defmodule GameRoom.GameInstance do
  use GenServer

  alias GameRoom.Game

  def start_link({game_type, id}) do
    alias GameRoom.Game.TicTacToe, as: TTT
    alias GameRoom.Player, as: P

    init = TTT.new(%P{id: 2}) |> GameRoom.Game.add_player(%P{id: 3})

    GenServer.start_link(__MODULE__, init, name: {:via, Registry, {GameRegistry, {game_type, id}}})
  end

  @impl true
  def init(state) do

    {:ok, state}
  end

  @impl true
  def handle_call(:players, _, state) do
    {:reply, Game.players(state), state}
  end

  @impl true
  def handle_call(:player_count, _, state) do
    {:reply, Game.players(state) |> length(), state}
  end
end
