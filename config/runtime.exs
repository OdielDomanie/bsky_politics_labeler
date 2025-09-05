import Config

config :bsky_politics_labeler,
  labeler_did: System.get_env("BSKY_POLITICS_LABELER_DID"),
  labeler_password: System.get_env("BSKY_POLITICS_LABELER_PASSWORD"),
  start_websocket: System.get_env("BSKY_POLITICS_LABELER_START_WEBSOCKET") == "true"

config :bsky_politics_labeler, BskyPoliticsLabeler.Repo,
  log: false,
  database: "bsky_politics_labeler_repo",
  username: "postgres",
  password: System.get_env("POSTGRES_PASSWORD", "dev_postgres_pw"),
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  port: System.get_env("POSTGRES_PORT", "5432")

config :ex_openai,
  base_url: System.get_env("OPENAI_URL", "http://127.0.0.1:8080")
