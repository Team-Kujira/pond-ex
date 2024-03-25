defmodule PondWeb.PageController do
  alias Cosmos.Base.Tendermint
  use PondWeb, :controller

  def index(conn, _params) do
    {:ok, %{block: block}} =
      Tendermint.V1beta1.Service.Stub.get_latest_block(
        Pond.Node.channel(),
        Tendermint.V1beta1.GetLatestBlockRequest.new()
      )

    conn |> assign(:block, block) |> render("index.html")
  end
end
