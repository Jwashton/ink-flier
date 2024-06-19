defmodule InkFlier.Repo do
  use Ecto.Repo,
    otp_app: :ink_flier,
    adapter: Ecto.Adapters.Postgres
end
