defmodule Wims.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Wims.Repo,
      WimsWeb.Telemetry,
      {Phoenix.PubSub, name: Wims.PubSub},
      WimsWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Wims.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    WimsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
