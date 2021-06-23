defmodule GameRoomWeb.LiveHelpers do
  import Phoenix.LiveView

  def assign_defaults(%{"user_id" => user_id}, socket) do
    assign(socket, user_id: user_id, query: "", results: %{})
  end
end
