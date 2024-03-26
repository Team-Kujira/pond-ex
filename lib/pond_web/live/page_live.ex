defmodule PondWeb.PageLive do
  use PondWeb, :live_view
  alias Cosmos.Base.Tendermint
  import Tendermint.V1beta1.Service.Stub
  alias Tendermint.V1beta1.GetLatestBlockRequest, as: LatestBlock
  alias Tendermint.V1beta1.GetBlockByHeightRequest, as: Block

  def mount(_params, _session, socket) do
    Pond.Node.subscribe("tendermint/event/NewBlock")

    {:ok, %{block: block}} = get_latest_block(Pond.Node.channel(), LatestBlock.new())

    {:ok, assign(socket, :block, block)}
  end

  def handle_info(%{block: %{header: %{height: height}}}, socket) do
    {:ok, %{block: block}} =
      get_block_by_height(
        Pond.Node.channel(),
        Block.new(height: String.to_integer(height))
      )

    {:noreply, assign(socket, :block, block)}
  end

  def handle_event("inc_temperature", _params, socket) do
    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end
end
