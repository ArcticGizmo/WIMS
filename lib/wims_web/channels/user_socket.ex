defmodule WimsWeb.UserSocket do
  use Phoenix.Socket

  @impl true
  def connect(_params, socket, _connect_info) do
    IO.inspect("---- socket and the such")
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
