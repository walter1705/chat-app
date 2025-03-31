import Config

config :chat_app, ChatApp.DB.Repo,
  database: "priv/repo/chat_app.db",
  username: "walter17",
  password: "walter17",
  hostname: "localhost",
  default_transaction_mode: :inmediate,
  pool_size: 5

config :chat_app, ecto_repos: [ChatApp.DB.Repo]
