defmodule MessageX.Repo do
  use Ecto.Repo,
    otp_app: :message_x,
    adapter: Ecto.Adapters.Postgres
end
