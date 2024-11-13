ExUnit.configure(exclude: [integration: true])
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(InkFlier.Repo, :manual)
