defmodule ElmPhoenix.Web.RoomChannel do
  use ElmPhoenix.Web, :channel
  alias ElmPhoenix.Web.Presence

  def join("room:lobby", %{"user_name" => user_name}, socket) do
    send(self(), {:after_join, user_name})
    {:ok, socket}
  end

  def handle_in("new_msg", %{"msg" => msg}, socket) do
    user_name = socket.assigns[:user_name]

    broadcast(socket, "new_msg", %{msg: msg, user_name: user_name})
    {:reply, :ok, socket}
  end

  def handle_info({:after_join, user_name}, socket) do
    push(socket, "presence_state", Presence.list(socket))
    {:ok, _ref} = Presence.track(socket, user_name, %{online_at: now()})
    {:noreply, assign(socket, :user_name, user_name)}
  end

  def terminate(_reason, socket) do
    {:noreply, socket}
  end

  defp now do
    System.system_time(:seconds)
  end
end
