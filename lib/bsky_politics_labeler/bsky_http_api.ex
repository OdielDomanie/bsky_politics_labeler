defmodule BskyPoliticsLabeler.BskyHttpApi do
  alias BskyPoliticsLabeler.{Post, Base32Sortable}

  def get_text(%Post{did: did, rkey: rkey}) do
    at_uri = "at://" <> did <> "/app.bsky.feed.post/" <> Base32Sortable.encode!(rkey)

    # dbg(at_uri)

    resp =
      Req.get!("/xrpc/app.bsky.feed.getPosts",
        base_url: "https://public.api.bsky.app",
        params: [uris: at_uri],
        http_errors: :raise
      )

    # dbg(did <> "/post/" <> Base32Sortable.encode!(rkey))

    %{
      "posts" => [
        %{
          "record" => %{
            "text" => text
          }
        }
      ]
    } = resp.body

    # dbg(text)
    text
  end
end

## resp.body

%{
  "posts" => [
    %{
      "author" => %{
        "associated" => %{
          "activitySubscription" => %{"allowSubscriptions" => "followers"}
        },
        "avatar" =>
          "https://cdn.bsky.app/img/avatar/plain/did:plc:z3ao6ykf6pihzfcbibccxkwa/bafkreicjewjk7apde2jqrkmus2tjkd4qlkqs6jact4g2f2qsr2q4umceny@jpeg",
        "createdAt" => "2025-02-24T23:34:20.346Z",
        "did" => "did:plc:z3ao6ykf6pihzfcbibccxkwa",
        "displayName" => "butterflygirl24",
        "handle" => "butterflygirl24.bsky.social",
        "labels" => []
      },
      "cid" => "bafyreigvmpinxt3ue7czpxepdt4uda37tg74h52vv2x2vuxrf4m6jrlegy",
      "embed" => %{
        "$type" => "app.bsky.embed.video#view",
        "aspectRatio" => %{"height" => 1280, "width" => 720},
        "cid" => "bafkreicdgbwmeqhzulfl5rsgahozpknogimicymyqlaoe3ym2ctgdwviby",
        "playlist" =>
          "https://video.bsky.app/watch/did%3Aplc%3Az3ao6ykf6pihzfcbibccxkwa/bafkreicdgbwmeqhzulfl5rsgahozpknogimicymyqlaoe3ym2ctgdwviby/playlist.m3u8",
        "thumbnail" =>
          "https://video.bsky.app/watch/did%3Aplc%3Az3ao6ykf6pihzfcbibccxkwa/bafkreicdgbwmeqhzulfl5rsgahozpknogimicymyqlaoe3ym2ctgdwviby/thumbnail.jpg"
      },
      "indexedAt" => "2025-08-30T19:20:43.907Z",
      "labels" => [],
      "likeCount" => 713,
      "quoteCount" => 10,
      "record" => %{
        "$type" => "app.bsky.feed.post",
        "createdAt" => "2025-08-30T19:20:41.578Z",
        "embed" => %{
          "$type" => "app.bsky.embed.video",
          "aspectRatio" => %{"height" => 1280, "width" => 720},
          "video" => %{
            "$type" => "blob",
            "mimeType" => "video/mp4",
            "ref" => %{
              "$link" => "bafkreicdgbwmeqhzulfl5rsgahozpknogimicymyqlaoe3ym2ctgdwviby"
            },
            "size" => 1_354_403
          }
        },
        "facets" => [
          %{
            "features" => [
              %{"$type" => "app.bsky.richtext.facet#tag", "tag" => "california"}
            ],
            "index" => %{"byteEnd" => 107, "byteStart" => 96}
          },
          %{
            "features" => [
              %{
                "$type" => "app.bsky.richtext.facet#tag",
                "tag" => "kamalaharris"
              }
            ],
            "index" => %{"byteEnd" => 121, "byteStart" => 108}
          }
        ],
        "langs" => ["en"],
        "text" =>
          "California Highway Patrol stepped up to protect our President. ✊🏼 Y’All know Kamala WON! #california #kamalaharris"
      },
      "replyCount" => 32,
      "repostCount" => 166,
      "uri" => "at://did:plc:z3ao6ykf6pihzfcbibccxkwa/app.bsky.feed.post/3lxnc6gbslc27"
    }
  ]
}

nil
