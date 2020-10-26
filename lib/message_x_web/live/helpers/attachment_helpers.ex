defmodule MessageXWeb.AttachmentHelpers do
  @moduledoc """
  Helpers for `MessageX.Chats.Attachment`.
  """

  import Phoenix.LiveView.Helpers

  use Phoenix.HTML

  alias MessageX.Chats.Attachment

  # @audio_mime_types [
  #   "audio/amr",
  #   "audio/x-m4a"
  # ]
  # @image_mime_types [
  #   "image/svg+xml",
  #   "image/png",
  #   "image/gif",
  #   "image/heic",
  #   "image/jpeg"
  # ]
  # @video_mime_types [
  #   "video/3gpp",
  #   "video/mp4",
  #   "video/quicktime"
  # ]
  # @document_mime_types [
  #   "application/msword",
  #   "application/postscript",
  #   "application/pdf",
  #   "text/plain",
  #   "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
  # ]
  # @other_mime_types [
  #   "text/vcard",
  #   "application/zip",
  #   "text/x-vlocation"
  # ]

  def render_missing_attachment(attachment, reason \\ "no filename") do
    content_tag(:pre, """
    [ATTACHMENT: #{reason}]

    #{
      inspect(
        attachment
        |> Map.drop([
          :__meta__,
          :__struct__,
          :attribution_info,
          :ck_server_change_token_blob,
          :messages,
          :message_attachments,
          :sr_ck_server_change_token_blob,
          :user_info,
          :uti
        ]),
        pretty: true,
        limit: :infinity
      )
    }
    """)
  end

  def render_attachment(%Attachment{hide_attachment: 1} = attachment) do
    nil
  end

  def render_attachment(%Attachment{mime_type: "image/" <> _, filename: nil} = attachment) do
    case find(attachment) do
      [] -> render_missing_attachment(attachment, "no filename")
      [path] -> render_thumb(rel_path(path), alt: attachment.transfer_name)
    end
  end

  def render_attachment(%Attachment{mime_type: "image/" <> _, filename: filename} = attachment)
      when is_binary(filename) do
    case find(attachment) do
      [] -> render_missing_attachment(attachment, "file not found")
      [path] -> render_thumb(rel_path(path), alt: attachment.transfer_name)
    end
  end

  def render_attachment(%Attachment{mime_type: "image/" <> _, filename: filename} = attachment)
      when is_binary(filename) do
    case find(attachment) do
      [] -> render_missing_attachment(attachment, "file not found")
      [path] -> render_thumb(rel_path(path), alt: attachment.transfer_name)
    end
  end

  def render_attachment(attachment) do
    render_missing_attachment(attachment, "mime not implemented")
  end

  def render_thumb(src, opts \\ []) do
    case src |> String.split(".") |> List.last() |> MIME.type() do
      "image/" <> _ ->
        img_tag(src, opts ++ [style: "max-width: 90%; max-height: 200px"])

      "video/" <> _ ->
        content_tag(
          :embed,
          [src: src, x: 200, y: 200] ++
            opts ++ [style: "max-width: 90%; max-height: 200px", target: "_blank"]
        )

      _ ->
        nil
        # render_missing_attachment(attachment, "invalid thumb mime not implemented")
    end
  end

  def rel_path("/home/sitch/sites/Messages/" <> path) do
    # "/Attachments/" <> path
    "/" <> path
  end

  def find(%Attachment{guid: guid, transfer_name: transfer_name, filename: nil} = attachment)
      when is_binary(guid) and is_binary(transfer_name) do
    with {:dir, [dir]} <- {:dir, Path.wildcard(dir(:attachments) <> "/**/#{guid}")},
         {:files, [_ | _] = files} <- {:files, Path.wildcard(dir <> "/*")} do
      # IO.inspect(dir: dir)
      # IO.inspect(found: files)
      files |> Enum.at(0) |> List.wrap()
    else
      # {:dir, []} -> []
      # {:files, []} -> []
      _ ->
        case Path.wildcard(dir(:attachments) <> "/**/#{transfer_name}") do
          [] ->
            []

          [path] ->
            IO.inspect("""
            #{IO.ANSI.red()}
            Attachment MAY be unclear"

            #{IO.ANSI.yellow()}
            PATH: #{inspect(path)}

            #{IO.ANSI.cyan()}
            #{inspect(attachment)}
            """)

            [path]
        end
    end
  end

  def dir(:attachments) do
    dir(:messages_root) <> "/Attachments"
  end

  def dir(:archive) do
    dir(:messages_root) <> "/Archive"
  end

  def dir(:sticker_cache) do
    dir(:messages_root) <> "/StickerCache"
  end

  def dir(:messages_root) do
    "/home/sitch/sites/Messages"
  end
end
