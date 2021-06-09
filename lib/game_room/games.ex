defmodule GameRoom.Games do
  use GenServer

  # probably separate out into genserver per game instance

  def start_link(_) do
    alias GameRoom.Game.TicTacToe, as: TTT
    alias GameRoom.Player, as: P

    init = %{
      1 => TTT.new(%P{id: 1}),
      2 => TTT.new(%P{id: 2}) |> GameRoom.Game.add_player(%P{id: 3}),
      3 => TTT.new(%P{id: 4}) |> GameRoom.Game.add_player(%P{id: 5}),
      4 => TTT.new(%P{id: 6})
    }

    GenServer.start_link(__MODULE__, init, name: :games)
  end

  def list_games() do
    GenServer.call(:games, :list_games)
  end

  @impl true
  def init(state) do

    {:ok, state}
  end

  @impl true
  def handle_call(:list_games, _, state) do
    {:reply, state, state}
  end
end
