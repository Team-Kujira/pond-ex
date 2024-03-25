# Pond

![screenshot](https://github.com/Team-Kujira/pond-ex/blob/main/priv/static/images/screenshot.png?raw=true)

The quickest way to start building your app on the Kujira DeFi Blockchain

First, start your local Pond network:

- `git clone https://github.com/Team-Kujira/pond.git`
- `cd pond && sudo cp pond /usr/local/bin/`
- `pond init`
- `pond start`

Then, clone and start your Pond application:

- `git clone https://github.com/Team-Kujira/pond-ex && cd pond-ex`
- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Kujira Website: https://kujira.network/
- kujira-ex Docs https://hexdocs.pm/kujira
- Kujira Developer Docs https://docs.kujira.app/developers/developer-kickstart-page
- Phoenix Website: https://www.phoenixframework.org/
- Phoenix Guides: https://hexdocs.pm/phoenix/overview.html
- Phoenix Docs: https://hexdocs.pm/phoenix
- Phoenix Forum: https://elixirforum.com/c/phoenix-forum
