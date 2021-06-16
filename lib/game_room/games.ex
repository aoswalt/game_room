defmodule GameRoom.Games do
  def list_player_counts() do
    Registry.select(GameRegistry, [{{:"$1", :"$2", :"$3"}, [], [{{:"$1", :"$2", :"$3"}}]}])
    |> Task.async_stream(fn {{module, _id}, pid, _} ->
      count = GenServer.call(pid, :player_count)
      {module, count}
    end)
    |> Enum.reduce(%{}, fn {:ok, {module, count}}, games ->
      Map.update(games, module, count, &(&1 + count))
    end)
  end
end
