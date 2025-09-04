# The record created by this code may be messing up Ozone.
# This code is unneeded since Ozone can be used to set this up.

# defmodule BskyPoliticsLabeler.Account do
#   require Logger

#   def put_labeler_service_record(did, session_manager) do
#     record = %{
#       "$type": "app.bsky.labeler.service",
#       policies: %{
#         labelValues: ["uspolitics"],
#         labelValueDefinitions: [
#           %{
#             identifier: "uspolitics",
#             severity: "alert",
#             blurs: "media",
#             defaultSetting: "warn",
#             locales: [%{lang: "en", name: "US Politics", description: "Posts about US Politics."}]
#           }
#         ]
#       },
#       subjectTypes: ["record"],
#       subjectCollections: ["app.bsky.feed.post"],
#       reasonTypes: ["com.atproto.moderation.defs#reasonOther"],
#       createdAt: DateTime.utc_now()
#     }

#     body = %{
#       repo: did,
#       collection: "app.bsky.labeler.service",
#       rkey: "self",
#       validate: true,
#       record: record
#     }

#     path = "/xrpc/com.atproto.repo.putRecord"

#     case Atproto.request([url: path, json: body, method: :post], session_manager)
#          |> Req.request() do
#       {:ok, %Req.Response{status: 200, body: body}} ->
#         # Logger.info("Put labeler service record: #{inspect(body)}")
#         {:ok, body}

#       {:ok, %Req.Response{status: status, body: body}} when status >= 400 ->
#         {:error,
#          %RuntimeError{
#            message: """
#            The requested URL returned error: #{status}
#            Response body: #{inspect(body)}\
#            """
#          }}

#       {:error, _} = err ->
#         err
#     end

#     # {:ok,
#     #   %{
#     #     "cid" => "bafyreidh7rcibn7rbcfdze5pwroucpbh4t7h66cwhoi7jh2kegq44w7fx4",
#     #     "commit" => %{
#     #       "cid" => "bafyreihs3r2lkdgbsjctszkw5qag6kg5qnvowlw3twaay262xgr4iq3okq",
#     #       "rev" => "3lxri5iimcf2p"
#     #     },
#     #     "uri" => "at://did:plc:r5ju6hyf6p7lufdpelj37wnk/app.bsky.labeler.service/3lxri5iihg52p",
#     #     "validationStatus" => "valid"
#     #   }}
#   end

#   def delete_labeler_service_record(did, session_manager) do
#     body = %{
#       repo: did,
#       collection: "app.bsky.labeler.service",
#       rkey: "self"
#     }

#     path = "/xrpc/com.atproto.repo.deleteRecord"

#     case Atproto.request([url: path, json: body, method: :post], session_manager)
#          |> Req.request() do
#       {:ok, %Req.Response{status: 200, body: body}} ->
#         # Logger.info("Put labeler service record: #{inspect(body)}")
#         {:ok, body}

#       {:ok, %Req.Response{status: status, body: body}} when status >= 400 ->
#         {:error,
#          %RuntimeError{
#            message: """
#            The requested URL returned error: #{status}
#            Response body: #{inspect(body)}\
#            """
#          }}

#       {:error, _} = err ->
#         err
#     end
#   end
# end
