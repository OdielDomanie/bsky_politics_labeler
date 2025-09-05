import Config

config :bsky_politics_labeler,
  ecto_repos: [BskyPoliticsLabeler.Repo]

# config :logger,
#   level: :info

config :logger,
  compile_time_purge_matching: [
    [application: :req, level_lower_than: :error]
    # [module: Bar, function: "foo/3", ]
  ]

# config :ex_openai,
#   api_key: "",
#   organization_key: ""

# Optional settings
# base_url: "http://127.0.0.1:8080"

# http_options: [recv_timeout: 50_000],
# http_headers: [{"OpenAI-Beta", "assistants=v2"}]

import_config "#{config_env()}.exs"
