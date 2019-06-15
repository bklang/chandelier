defmodule Chandelier.Repo do
  use Ecto.Repo,
    otp_app: :chandelier,
    adapter: Ecto.Adapters.Postgres
end
