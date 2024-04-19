defmodule PondWeb.PageLive do
  use PondWeb, :live_view
  alias Cosmos.Base.Tendermint
  import Tendermint.V1beta1.Service.Stub
  alias Tendermint.V1beta1.GetLatestBlockRequest, as: LatestBlock
  alias Tendermint.V1beta1.GetBlockByHeightRequest, as: Block

  def mount(_params, _session, socket) do
    Pond.Node.subscribe("tendermint/event/NewBlock")

    {:ok, %{block: block}} = get_latest_block(Pond.Node.channel(), LatestBlock.new())

    {:ok,
     socket
     |> assign(:block, block)
     |> assign(:sonar_connect_uri, nil)
     |> assign(:sonar_address, nil)}
  end

  def handle_info(%{block: %{header: %{height: height}}}, socket) do
    {:ok, %{block: block}} =
      get_block_by_height(
        Pond.Node.channel(),
        Block.new(height: String.to_integer(height))
      )

    {:noreply, assign(socket, :block, block)}
  end

  def handle_event("sonar-connect-request", %{"uri" => uri}, socket) do
    {:noreply, assign(socket, :sonar_connect_uri, uri)}
  end

  def handle_event("sonar-connect-response", %{"address" => address}, socket) do
    {:noreply,
     socket
     |> assign(:sonar_address, address)
     |> assign(:sonar_connect_uri, nil)}
  end

  def handle_event("sonar-disconnect", _params, socket) do
    {:noreply, assign(socket, :sonar_address, nil)}
  end

  def qr(uri) do
    case uri
         |> QRCode.create()
         |> QRCode.render(:svg, %QRCode.Render.SvgSettings{
           background_opacity: 0.0,
           qrcode_color: "#ffffff"
         })
         |> QRCode.to_base64() do
      {:ok, data} -> img_tag("data:image/svg+xml; base64, #{data}")
      {:error, err} -> err
    end
  end
end
