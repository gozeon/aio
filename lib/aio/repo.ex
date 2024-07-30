defmodule Aio.Repo do
  use Ecto.Repo,
    otp_app: :aio,
    adapter: Ecto.Adapters.Postgres
end
