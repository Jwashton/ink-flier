defmodule Mix.Tasks.Test.Integration do
  @moduledoc """
  Tests that simulate if Application started everything up normally, including GameSystem,
  which normally ISN'T started in test env
    - Because most tests handle it themselves with start_supervised!
    - Which they do to clear state inbetween each test

  Run with `mix test.integration`

  To tag a test to be run in (and only in) this environment, use: `@tag integration: true`
  """
  @shortdoc "Integration tests that startup Game System just like a live environment"
  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    System.put_env("MIX_ENV", "integration")
    Mix.Task.run("test", ["--only", "integration"])
  end
end
