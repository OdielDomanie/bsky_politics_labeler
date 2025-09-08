import Config

config :bsky_politics_labeler,
  labeler_did: System.get_env("BSKY_POLITICS_LABELER_DID"),
  labeler_password: System.get_env("BSKY_POLITICS_LABELER_PASSWORD"),
  start_websocket: System.get_env("BSKY_POLITICS_LABELER_START_WEBSOCKET") == "true",
  simulate_emit_event: System.get_env("BSKY_POLITICS_LABELER_SIMULATE") == "true",
  min_likes:
    System.get_env("BSKY_POLITICS_LABELER_MIN_LIKES", "50")
    |> String.to_integer(),
  regex_file: System.get_env("BSKY_POLITICS_LABELER_REGEX_FILE", "patterns.txt"),
  admin_dashboard_password: System.get_env("BSKY_POLITICS_DASHBOARD_PASSWORD")

config :bsky_politics_labeler, BskyPoliticsLabeler.Repo,
  log: false,
  database: "bsky_politics_labeler_repo",
  username: "postgres",
  password: System.get_env("POSTGRES_PASSWORD", "dev_postgres_pw"),
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  port: System.get_env("POSTGRES_PORT", "5432")

config :ex_openai,
  base_url: System.get_env("OPENAI_URL", "http://127.0.0.1:8080")

config :bsky_politics_labeler, BskyPoliticsLabeler.WebEndpoint,
  secret_key_base: System.get_env("PHOENIX_SECRET_KEY_BASE")
