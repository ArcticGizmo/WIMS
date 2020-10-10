defmodule WimsWeb.TCP.Server do
  require Logger

  use GenServer

  def start_link(_opts) do
    port = 4010
    # ip = ip || Application.get_env(:wims, WimsWeb.TCP)
    GenServer.start_link(__MODULE__, port)
  end

  def init(port) do
    {:ok, port, {:continue, :connect}}
  end

  def handle_continue(:connect, port) do
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: true, reuseaddr: true])

    Logger.info("[TCP] Running #{__MODULE__} on port #{port}")
    # this hangs until a message is recieved
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    {:noreply, %{port: port, socket: socket}}
  end

  def handle_info({:tcp, socket, packet}, state) do
    Logger.info("[TCP] RECV: '#{packet}'")
    :gen_tcp.send(socket, "reflext: msg length #{String.length(packet)}")
    {:noreply, state}
  end

  def handle_info({:tcp_closed, _socket}, state) do
    Logger.error("[TCP] Socket closed")
    {:noreply, state}
  end

  def handle_info({:tcp_error, _socket, reason}, state) do
    Logger.error("[TCP] Connection closed due to #{reason}")
    {:reply, state}
  end

  # def accept(port) do
  #   {:ok, socket} =
  #     :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

  #   Logger.info("[TCP] Accepting connections on port #{port}")
  #   loop_acceptor(socket)
  # end

  # defp loop_acceptor(socket) do
  #   {:ok, client} = :gen_tcp.accept(socket)
  #   serve(client)
  #   loop_acceptor(socket)
  # end

  # defp serve(socket) do
  #   _recv = read_line(socket)
  #   write_line("Got message", socket)

  #   serve(socket)
  # end

  # defp read_line(socket) do
  #   {:ok, data} = :gen_tcp.recv(socket, 0)
  #   Logger.info("[TCP] RECV: '#{data}'")
  #   data
  # end

  # defp write_line(line, socket) do
  #   Logger.info("[TCP] SEND: '#{line}'")
  #   :gen_tcp.send(socket, line)
  # end
end
