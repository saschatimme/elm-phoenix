defmodule ElmPhoenix.RoomChannel do
  use Phoenix.Channel
  require Logger
  alias ElmPhoenix.OnlineUsers

  def join("room:lobby", %{"user_name" => user_name }, socket) do
    user_name_taken =
      OnlineUsers.is_joined (user_name)

    if user_name_taken do
      {:error, %{"user_name_taken" => user_name}}

    else
      OnlineUsers.joined (user_name)
      send self, %{user_joined: user_name}
      {:ok, socket |> assign(:user_name, user_name)}
    end
  end

  def handle_in("new_msg", %{"msg" => msg}, socket) do
    user_name =
      socket.assigns[:user_name]

    broadcast socket, "new_msg", %{msg: msg, user_name: user_name}
    {:reply, :ok, socket}
  end

  def handle_info(%{user_joined: user_name}, socket) do
    broadcast! socket, "user_joined", %{user_name: user_name}
    {:noreply, socket}
  end

  def leave(_reason, socket) do
    OnlineUsers.left (socket.assigns["user_name"])

    {:ok, socket}
  end

  def terminate(_reason, socket) do
    OnlineUsers.left (socket.assigns["user_name"])
    {:shutdown, :closed}
  end

  # def handle(msg, payload, socket) do
  #   inspect(msg)
  #   {:reply, socket}
  # end
end
