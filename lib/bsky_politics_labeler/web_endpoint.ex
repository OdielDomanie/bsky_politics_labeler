defmodule BskyPoliticsLabeler.WebEndpoint.Router do
  use Phoenix.Router, helpers: false
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers
  end

  pipeline :admin_auth do
    plug :admin_basic_auth
  end

  scope "/admin" do
    pipe_through [:browser, :admin_basic_auth]

    live_dashboard "/dashboard"
  end

  defp admin_basic_auth(conn, _opts) do
    username = "admin"
    password = Application.get_env(:bsky_politics_labeler, :admin_dashboard_password)

    if !password do
      send_resp(conn, 404, "Not found") |> halt()
    else
      Plug.BasicAuth.basic_auth(conn, username: username, password: password)
    end
  end
end

defmodule BskyPoliticsLabeler.WebEndpoint do
  use Phoenix.Endpoint, otp_app: :bsky_politics_labeler

  socket("/live", Phoenix.LiveView.Socket,
    websocket: true,
    longpoll: true
  )

  plug Plug.Head

  plug BskyPoliticsLabeler.WebEndpoint.Router
end
