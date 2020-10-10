defmodule WimsWeb.RawSocket do
  use WimsWeb.Socket.Raw

  @impl true
  def connect(_params, socket, _connect_info) do
    IO.inspect("---- socket and the such")
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
