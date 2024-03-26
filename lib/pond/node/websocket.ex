defmodule Pond.Node.Websocket do
  use WebSockex
  require Logger

  def start_link(config) do
    endpoint = config[:websocket]
    Logger.info("#{__MODULE__} Starting node websocket: #{endpoint}")
    {:ok, pid} = WebSockex.start_link("#{endpoint}/websocket", __MODULE__, %{})
    subscribe(pid, 0, "tm.event='NewBlock'")
    {:ok, pid}
  end

  def handle_connect(_conn, state) do
    Logger.info("#{__MODULE__} Connected!")

    {:ok, state}
  end

  def handle_disconnect(_status, _state) do
    raise "#{__MODULE__} Disconnected"
  end

  def handle_frame({:text, msg}, state) do
    case Jason.decode(msg, keys: :atoms) do
      {:ok, %{result: %{data: %{type: t, value: v}}}} ->
        Phoenix.PubSub.broadcast(Pond.PubSub, t, v)

        {:ok, state}

      _ ->
        {:ok, state}
    end
  end

  def handle_cast({:send, {_type, msg} = frame}, state) do
    Logger.debug("#{__MODULE__} [send] #{msg}")

    {:reply, frame, state}
  end

  defp subscribe(pid, id, query) do
    message =
      Jason.encode!(%{
        jsonrpc: "2.0",
        method: "subscribe",
        id: id,
        params: %{
          query: query
        }
      })

    WebSockex.send_frame(pid, {:text, message})
  end
end
