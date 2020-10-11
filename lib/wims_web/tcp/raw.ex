defmodule WimsWeb.TCP.Raw do
  @type transport :: any()
  @type msg :: String.t()

  @callback handle_msg(msg, transport) :: {:no_reply, transport} | {:reply, msg, transport}

  @callback on_close(reason :: term) :: no_return()

  require Logger

  def __start__(module, opts) do
    Logger.info("[#{module}] Started on port x")
    pid = :proc_lib.spawn_link(module, :init, opts)
    {:ok, pid}
  end

  def __reply__({:noreply, _}, state), do: {:no_reply, state}

  def __reply__({:reply, message, _}, state) when is_binary(message) do
    state.transport.send(state.socket, message)
    {:noreply, state}
  end

  def __terminate__(module, reason, state) do
    Logger.error("[#{module}] Terminated")
    IO.inspect(reason)
    IO.inspect(state)
  end

  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @behaviour WimsWeb.TCP.Raw

      @behaviour :ranch_protocol

      def start_link(ref, socket, transport, _opts),
        do: WimsWeb.TCP.Raw.__start__(__MODULE__, [ref, socket, transport])

      def init(ref, socket, transport) do
        :ok = :ranch.accept_ack(ref)
        :ok = transport.setopts(socket, [{:active, true}, reuseaddr: true])
        :gen_server.enter_loop(__MODULE__, [], %{ref: ref, socket: socket, transport: transport})
      end

      def handle_info({:tcp, _socket, data}, state) do
        apply(__MODULE__, :handle_msg, [data, state.transport])
        |> WimsWeb.TCP.Raw.__reply__(state)
      end

      def handle_info({:tcp_closed, _socket}, state) do
        apply(__MODULE__, :on_close, [:tcp_closed])
        state.transport.close(state.socket)
        {:stop, :normal, state}
      end

      def terminate(reason, state), do: WimsWeb.TCP.Raw.__terminate__(__MODULE__, reason, state)
    end
  end
end
