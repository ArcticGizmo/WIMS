defmodule Wims.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Wims.Repo,
      WimsWeb.Telemetry,
      {Phoenix.PubSub, name: Wims.PubSub},
      # WimsWeb.Endpoint
      # {WimsWeb.TCP.Server, []}
      # {WimsWeb.TCP.Server2, 4010},
      # {DynamicSupervisor, strategy: :one_for_one, name: WimsWeb.TCP.ClientSupervisor}
    ]

    # WimsWeb.TCP.Server.accept(4010)

    opts = [strategy: :one_for_one, name: Wims.Supervisor]
    ret = Supervisor.start_link(children, opts)

    :ranch.start_listener(make_ref(), :ranch_tcp, [{:port, 4010}], WimsWeb.TCP.Protocol, [])

    ret
  end

  def config_change(changed, _new, removed) do
    WimsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
