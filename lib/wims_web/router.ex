defmodule WimsWeb.Router do
  use WimsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WimsWeb do
    pipe_through :api
  end

  scope "/api/sockets/unsecure", WimsWeb do
    pipe_through :api

    get("/", SocketController, :login)
  end


end
