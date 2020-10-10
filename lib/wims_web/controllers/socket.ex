defmodule WimsWeb.SocketController do
  use WimsWeb, :controller

  def login(conn, _params) do
    IO.inspect(conn)
    IO.inspect(_params)
    send_resp(conn, 101, "")
  end
end
