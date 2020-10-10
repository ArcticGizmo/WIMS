defmodule WimsWeb.Router do
  use WimsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WimsWeb do
    pipe_through :api
  end
end
