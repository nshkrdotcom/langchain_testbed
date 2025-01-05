defmodule LangchainTestbed.Application do
  use Application

  @impl true
  def start(_type, _args) do
    # Start the main task under the supervision tree
    children = [
#      {Task, &LangchainTestbed.run/0}
    ]

    opts = [strategy: :one_for_one, name: LangchainTestbed.Supervisor]
    Supervisor.start_link(children, opts)

    LangchainTestbed.start(:normal, [])
  end
end
