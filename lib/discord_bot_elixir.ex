defmodule DiscordBotElixir.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DiscordBotElixir.Store,
      DiscordBotElixir.Consumer
    ]

    opts = [
      strategy: :one_for_one,
      name: DiscordBotElixir.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end