defmodule PondWeb.PageLive do
  use PondWeb, :live_view
  alias Cosmos.Base.Tendermint

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Pond.PubSub, "tendermint/event/NewBlock")

    {:ok, %{block: block}} =
      Tendermint.V1beta1.Service.Stub.get_latest_block(
        Pond.Node.channel(),
        Tendermint.V1beta1.GetLatestBlockRequest.new()
      )

    {:ok, assign(socket, :block, block)}
  end

  def handle_info(%{block: %{header: %{height: height}}}, socket) do
    {:ok, %{block: block}} =
      Tendermint.V1beta1.Service.Stub.get_block_by_height(
        Pond.Node.channel(),
        Tendermint.V1beta1.GetBlockByHeightRequest.new(height: String.to_integer(height))
      )

    {:noreply, assign(socket, :block, block)}
  end

  def handle_event("inc_temperature", _params, socket) do
    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end
end
