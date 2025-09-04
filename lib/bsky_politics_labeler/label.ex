defmodule BskyPoliticsLabeler.Label do
  require Logger
  alias BskyPoliticsLabeler.Base32Sortable
  alias BskyPoliticsLabeler.{BskyHttpApi, Post}

  def label(post, subject_cid, labeler_did, session_manager) do
    text = BskyHttpApi.get_text(post)
    is_political = ask_ai(text)
    Logger.debug("#{is_political}: #{text}")

    if is_political do
      put_us_politics_label(post, subject_cid, labeler_did, session_manager)
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

    # {
    #   "subject": {
    #     "$type": "com.atproto.repo.strongRef",
    #     "uri": "at://did:plc:vt.../app.bsky.feed.post/3lu...",
    #     "cid": "baf..."
    #   },
    #   "createdBy": "did:plc:r5...",
    #   "subjectBlobCids": [],
    #   "event": {
    #     "$type": "tools.ozone.moderation.defs#modEventLabel",
    #     "comment": "",
    #     "createLabelVals": [
    #       "uspol"
    #     ],
    #     "negateLabelVals": [],
    #     "durationInHours": 0
    #   }
    # }

    body = %{
      event: %{
        "$type": "tools.ozone.moderation.defs#modEventLabel",
        comment: "ai",
        createLabelVals: ["uspol"],
        negateLabelVals: []
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

  def ask_ai(text) do
    # List available models
    {:ok, %{data: [%{id: model}]}} = ExOpenAI.Models.list_models()

    content =
      "\"#{text}\"\nIs the above post about US Politics or about the US legal system? Answer with only Yes or No."

    # Chat completion
    messages = [
      %ExOpenAI.Components.ChatCompletionRequestSystemMessage{
        role: :system,
        content: "You are a helpful assistant."
      },
      %ExOpenAI.Components.ChatCompletionRequestUserMessage{
        role: :user,
        content: content
      }
    ]

    true = !!Application.get_env(:ex_openai, :base_url)

    {:ok, response} =
      ExOpenAI.Chat.create_chat_completion(messages, model,
        temperature: 0,
        max_tokens: 3
      )

    %ExOpenAI.Components.CreateChatCompletionResponse{choices: [%{message: %{content: answer}}]} =
      response

    answer = answer |> String.trim(".") |> String.downcase()

    case answer do
      "no" -> false
      "yes" -> true
    end
  end
end
