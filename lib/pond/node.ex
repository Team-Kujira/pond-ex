defmodule Pond.Node do
  use Kujira.Node,
    otp_app: :pond,
    pubsub: Pond.PubSub,
    subscriptions: ["tm.event='NewBlock'"]
end
