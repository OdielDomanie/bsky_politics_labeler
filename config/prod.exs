import Config

config :logger,
  level: :info

# Caution! No HTTPS & Basic Auth means the app must be behind further layers of protection.
config :bsky_politics_labeler, BskyPoliticsLabeler.WebEndpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000]
