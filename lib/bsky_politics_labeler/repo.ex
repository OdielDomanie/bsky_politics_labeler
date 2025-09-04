defmodule BskyPoliticsLabeler.Repo do
  use Ecto.Repo,
    otp_app: :bsky_politics_labeler,
    adapter: Ecto.Adapters.Postgres
end
