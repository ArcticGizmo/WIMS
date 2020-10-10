defmodule WimsWeb.TCP.Server do
  require Logger

  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("[TCP] Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    serve(client)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    _recv = read_line(socket)
    write_line("Got message", socket)

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    Logger.info("[TCP] RECV: '#{data}'")
    data
  end

  defp write_line(line, socket) do
    Logger.info("[TCP] SEND: '#{line}'")
    :gen_tcp.send(socket, line)
  end
end
