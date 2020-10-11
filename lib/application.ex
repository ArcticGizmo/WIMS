defmodule Wims.Application do
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    children = [
      # Wims.Repo,
      WimsWeb.Telemetry,
      {Phoenix.PubSub, name: Wims.PubSub},
      # WimsWeb.Endpoint
      # {WimsWeb.TCP.Server, []}
      # {WimsWeb.TCP.Server2, 4010},
      # {DynamicSupervisor, strategy: :one_for_one, name: WimsWeb.TCP.ClientSupervisor}
    ] ++ ranch_protocols([])

    # WimsWeb.TCP.Server.accept(4010)

    opts = [strategy: :one_for_one, name: Wims.Supervisor]
    ret = Supervisor.start_link(children, opts)

    # start ranch listening protocols

    # :ranch.start_listener(make_ref(), :ranch_tcp, [{:port, 4010}], WimsWeb.TCP.Protocol, [])
    # Logger.info("[Socket] Listening on port #{4010}")
    ret
  end

  defp ranch_protocols(_protos) do
    [
      :ranch.child_spec(
        :tracker_one, :ranch_tcp,
        [{:port, 4010}],
        # WimsWeb.TCP.Simple,
        WimsWeb.Socket.TrackerOne,
        []
      )
    ]
  end

  def config_change(changed, _new, removed) do
    WimsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
