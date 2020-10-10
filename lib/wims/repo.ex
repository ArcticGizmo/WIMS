defmodule Wims.Repo do
  use Ecto.Repo,
    otp_app: :wims,
    adapter: Ecto.Adapters.Postgres
end
