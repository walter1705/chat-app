defmodule ChatApp.Application do
  use Application

  alias ChatApp.App.{Session}

  def start(_type, _args) do
    children = [
      {ChatApp.Data.Repo, []},
      {Session, []}
    ]

    opts = [strategy: :one_for_one, name: ChatApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
