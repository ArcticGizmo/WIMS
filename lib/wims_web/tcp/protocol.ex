defmodule WimsWeb.TCP.Protocol do

  require Logger

  @behaviour :ranch_protocol

  def start_link(ref, socket, transport, _opts) do
    pid = :proc_lib.spawn_link(__MODULE__, :init, [ref, socket, transport])
    {:ok, pid}
  end

  def init(ref, socket, transport) do
    Logger.info("[Proto] Starting on #{inspect(ref)}")

    :ok = :ranch.accept_ack(ref)
    :ok = transport.setopts(socket, [{:active, true}, reuseaddr: true])
    :gen_server.enter_loop(__MODULE__, [], %{ref: ref, socket: socket, transport: transport})
  end


  def handle_info({:tcp, _socket, data}, %{socket: socket, transport: transport} = state) do
    Logger.info("[Proto] RECV: '#{data}'")
    IO.inspect(socket)
    IO.inspect(transport)
    IO.inspect(state.ref)

    transport.send(socket, data)

    Port.info(socket)
    |> IO.inspect()
    {:noreply, state}
  end

  def handle_info({:tcp_closed, _socket}, %{socket: socket, transport: transport} = state) do
    Logger.info("[Proto] Closed")
    transport.close(socket)
    {:stop, :normal, state}
  end
end
