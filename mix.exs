defmodule ChatApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :chat_app,
      version: "0.1.0",
      elixir: "~> 1.17",
      name: "chat app",
      escripts: escript_config(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def escript_config do
    [main_module: CLI.Main]
  end

  def application do
    [
      mod: {ChatApp.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto_sqlite3, "~> 0.19.0"}, #SQLite3 adapter that inclute Ecto and EctoSQL
      {:bcrypt_elixir, "~> 3.2"}, #Password hashing algorithm for Elixir
      {:table_rex, "~> 4.1"} #Tool for pretty table string formating
    ]
  end
end
