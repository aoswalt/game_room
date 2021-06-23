defmodule GameRoomWeb.Plugs.UserId do
  @behaviour Plug

  import Plug.Conn

  @impl true
  def init(default), do: default

  @impl true
  def call(conn, _config) do
    case get_session(conn, :user_id) do
      nil ->
        user_id = unique_user_id()
        put_session(conn, :user_id, user_id)

      _user_id ->
        conn
    end
  end

  defp unique_user_id() do
    :crypto.strong_rand_bytes(16) |> Base.encode16()
  end
end
