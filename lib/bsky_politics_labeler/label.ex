defmodule BskyPoliticsLabeler.Label do
  require Logger
  alias BskyPoliticsLabeler.Base32Sortable
  alias BskyPoliticsLabeler.{BskyHttpApi, Post, GenAi}

  def label(post, subject_cid, labeler_did, session_manager) do
    text = BskyHttpApi.get_text(post)
    is_political = GenAi.ask_ai(text)
    Logger.debug("#{is_political}: #{text}")

    if is_political do
      if not Application.get_env(:bsky_politics_labeler, :simulate_emit_event) do
        put_us_politics_label(post, subject_cid, labeler_did, session_manager)
      end
    end
  end

  def put_us_politics_label(
        %Post{did: subject_did, rkey: subject_rkey},
        subject_cid,
        labeler_did,
        session_manager
      ) do
    subject_rkey = Base32Sortable.encode!(subject_rkey)

    subject_uri = "at://#{subject_did}/app.bsky.feed.post/#{subject_rkey}"

    path = "/xrpc/tools.ozone.moderation.emitEvent"
    method = :post

    body = %{
      event: %{
        "$type": "tools.ozone.moderation.defs#modEventLabel",
        comment: "ai",
        createLabelVals: ["uspol"],
        negateLabelVals: []
        #  durationInHours: 0
      },
      subject: %{
        "$type": "com.atproto.repo.strongRef",
        uri: subject_uri,
        cid: subject_cid
      },
      createdBy: labeler_did
    }

    case Atproto.request([url: path, json: body, method: method], session_manager)
         |> Req.merge(headers: ["atproto-proxy": labeler_did <> "#atproto_labeler"])
         |> Req.request() do
      {:ok, %Req.Response{status: 200, body: body}} ->
        # Logger.info("Put labeler service record: #{inspect(body)}")
        {:ok, body}

      {:ok, %Req.Response{status: status, body: body}} when status >= 400 ->
        {:error,
         %RuntimeError{
           message: """
           The requested URL returned error: #{status}
           Response body: #{inspect(body)}\
           """
         }}

      {:error, _} = err ->
        err
    end
  end
end
