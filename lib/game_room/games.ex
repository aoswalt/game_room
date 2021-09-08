defmodule GameRoom.Games do
  def list_player_counts() do
    Registry.select(GameRegistry, [{{:"$1", :"$2", :"$3"}, [], [{{:"$1", :"$2", :"$3"}}]}])
    |> Task.async_stream(fn {{module, _id, _}, pid, _} ->
      count = GenServer.call(pid, :player_count)
      {module, count}
    end)
    |> Enum.reduce(%{}, fn {:ok, {module, count}}, games ->
      Map.update(games, module, count, &(&1 + count))
    end)
  end

  def list_all_games() do
    Registry.select(GameRegistry, [{{:"$1", :"$2", :"$3"}, [], [{{:"$1", :"$2", :"$3"}}]}])
  end

  def list_game_instance_entries(module, id) do
    Registry.select(GameRegistry, [
      {
        {:"$1", :"$2", :"$3"},
        [
          {:==, {:element, 1, :"$1"}, module},
          {:==, {:element, 2, :"$1"}, id},
        ],
        [{{:"$1", :"$2", :"$3"}}]
      }
    ])
  end

  def list_open_games(module \\ nil) do
    module_match = if module, do: {:==, {:element, 1, :"$1"}, module}, else: true

    Registry.select(GameRegistry, [
      {
        {:"$1", :"$2", :"$3"},
        [
          {:==, :"$3", :open},
          module_match
        ],
        [{{:"$1", :"$2", :"$3"}}]
      }
    ])
  end

  def get_game(module, id, player) do
    [{pid, _value}] = Registry.lookup(GameRegistry, {module, id, player})
    pid
  end
end
