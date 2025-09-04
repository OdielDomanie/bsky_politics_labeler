defmodule BskyPoliticsLabeler.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    labeler_did = Application.fetch_env!(:bsky_politics_labeler, :labeler_did)
    labeler_password = Application.fetch_env!(:bsky_politics_labeler, :labeler_password)

    children = [
      BskyPoliticsLabeler.Repo,
      {Task.Supervisor, name: BskyPoliticsLabeler.Label.TaskSV, max_children: 20},
      {Atproto.SessionManager,
       name: BskyPoliticsLabeler.Atproto.SessionManager,
       did: labeler_did,
       password: labeler_password}
    ]

    children =
      children ++
        if Application.get_env(:bsky_politics_labeler, :start_websocket) do
          [
            {BskyPoliticsLabeler.Websocket,
             labeler_did: labeler_did, session_manager: BskyPoliticsLabeler.Atproto.SessionManager}
          ]
        else
          []
        end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: BskyPoliticsLabeler.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
