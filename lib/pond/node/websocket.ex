defmodule Pond.Node.Websocket do
  use WebSockex
  require Logger

  @topic inspect(__MODULE__)
  def subscribe do
    Phoenix.PubSub.subscribe(Kujira.PubSub, @topic)
  end

  def start_link(config) do
    endpoint = config[:websocket]
    Logger.info("#{__MODULE__} Starting node websocket: #{endpoint}")
    parent = self()
    WebSockex.start_link("#{endpoint}/websocket", __MODULE__, %{parent: parent})
  end

  def send(pid, message) do
    message = Jason.encode!(message)
    Logger.info("#{__MODULE__} Sending message: #{message}")
    WebSockex.send_frame(pid, {:text, message})
  end

  def handle_connect(conn, state) do
    Logger.info("#{__MODULE__} Connected!")

    {:ok, state}
  end

  def handle_disconnect(_status, _state) do
    raise "#{__MODULE__} Disconnected"
  end

  def handle_frame({:text, msg}, state) do
    Kernel.send(state.parent, {__MODULE__, msg})

    {:ok, state}
  end

  def handle_cast({:send, {_type, msg} = frame}, state) do
    Logger.debug("#{__MODULE__} [send] #{msg}")

    {:reply, frame, state}
  end
end
