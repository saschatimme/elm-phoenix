defmodule ElmPhoenix.OnlineUsers do

  def start_link do
    Agent.start_link(fn -> MapSet.new end, name: __MODULE__)
  end

  def joined (user_name) do
    Agent.update(__MODULE__, fn state -> MapSet.put(state, user_name) end)
  end

  def left (user_name) do
    Agent.update(__MODULE__, fn state -> MapSet.delete(state, user_name) end)
  end

  def is_joined (user_name) do
    Agent.get(__MODULE__, fn state -> MapSet.member?(state, user_name) end)
  end

end
