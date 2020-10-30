defmodule MessageX.ChatDB.LocalAttachments do
  @moduledoc """
  FileAttachment component.
  """

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

  def rel_path("/home/sitch/sites/Messages/" <> path) do
    # "/Attachments/" <> path
    "/" <> path
  end

  def find(%Attachment{} = attachment) do
    with :error <- search(attachment, :by_filename),
         :error <- search(attachment, :guid_dir),
         :error <- search(attachment, :attachments_dir) do
      :error
    end
  end

  def search(%Attachment{filename: filename}, :by_filename = search) when is_binary(filename) do
    path = Path.expand(filename)

    if File.exists?(path) do
      {:ok, {search, [path]}}
    else
      :error
    end
  end

  def search(%Attachment{guid: guid}, :guid_dir = search) when is_binary(guid) do
    with [dir] <- Path.wildcard(dir(:attachments) <> "/**/#{guid}"),
         true <- File.dir?(dir),
         paths = [_ | _] <- Path.wildcard(dir <> "/*") do
      {:ok, {search, paths}}
    else
      _ -> :error
    end
  end

  def search(%Attachment{transfer_name: transfer_name}, :attachments_dir = search)
      when is_binary(transfer_name) do
    case Path.wildcard(dir(:attachments) <> "/**/#{transfer_name}") do
      [] -> :error
      paths -> {:ok, {search, paths}}
    end
  end

  def search(%Attachment{}, _search) do
    :error
  end

  def media_type(%Attachment{mime_type: "image/" <> _}), do: "image"
  def media_type(%Attachment{mime_type: "video/" <> _}), do: "video"
  def media_type(%Attachment{mime_type: "audio/" <> _}), do: "audio"
  def media_type(%Attachment{}), do: "other"

  def alt_name(%Attachment{transfer_name: transfer_name}) do
    transfer_name
  end
end
