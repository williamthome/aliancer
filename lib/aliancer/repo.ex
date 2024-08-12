defmodule Aliancer.Repo do
  use Ecto.Repo,
    otp_app: :aliancer,
    adapter: Ecto.Adapters.Postgres
end
