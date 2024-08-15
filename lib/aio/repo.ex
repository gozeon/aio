defmodule Aio.Repo do
  use Ecto.Repo,
    otp_app: :aio,
    adapter: Ecto.Adapters.SQLite3
end
