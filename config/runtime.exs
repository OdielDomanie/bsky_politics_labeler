import Config

config :bsky_politics_labeler,
  labeler_did: System.get_env("BSKY_POLITICS_LABELER_DID"),
  labeler_password: System.get_env("BSKY_POLITICS_LABELER_PASSWORD"),
  start_websocket: System.get_env("BSKY_POLITICS_LABELER_PASSWORD_START_WEBSOCKET") == "true"
