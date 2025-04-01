defmodule ChatApp.Data.Repo do
  use Ecto.Repo,
    otp_app: :chat_app,
    adapter: Ecto.Adapters.SQLite3


end
