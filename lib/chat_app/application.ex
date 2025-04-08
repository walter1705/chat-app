defmodule ChatApp.Application do
  use Application

  def start(_type, _args) do
    children = [
      {ChatApp.Data.Repo, []}
    ]

    opts = [strategy: :one_for_one, name: ChatApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
