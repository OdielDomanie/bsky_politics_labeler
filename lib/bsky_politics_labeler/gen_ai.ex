defmodule BskyPoliticsLabeler.GenAi do
  require Logger

  @doc """
  Asks AI if the text is us-political.
  """
  def ask_ai(text) do
    # List available models
    t0 = System.monotonic_time()

    # This can also be used to measure queue health
    {:ok, %{data: [%{id: model}]}} =
      ExOpenAI.Models.list_models(
        timeout: 120_000,
        recv_timeout: 120_000
      )

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

    ExOpenAI.Chat.create_chat_completion(messages, model,
      temperature: 0,
      max_tokens: 3,
      timeout: 120_000,
      recv_timeout: 120_000
    )
    |> tap(fn _ ->
      t1 = System.monotonic_time()
      dur = System.convert_time_unit(t1 - t0, :native, :millisecond) / 1000
      Logger.debug("Inference took #{dur} s")
    end)
    |> case do
      {:ok, response} ->
        %ExOpenAI.Components.CreateChatCompletionResponse{
          choices: [%{message: %{content: answer}}]
        } =
          response

        answer = answer |> String.trim(".") |> String.downcase()

        case answer do
          "no" -> false
          "yes" -> true
        end

      {:error, :timeout} ->
        raise "Inference timeout"

      error ->
        raise "Inference error: " <> inspect(error)
    end
  end
end
