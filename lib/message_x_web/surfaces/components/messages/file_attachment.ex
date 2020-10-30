defmodule MessageXWeb.Components.FileAttachment do
  @moduledoc """
  FileAttachment component.
  """

  use MessageXWeb, :surface_component

  alias MessageX.ChatDB.LocalAttachments
  alias MessageXWeb.Components.Thumbnail

  prop attachment, :map, required: true

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    case LocalAttachments.find(assigns.attachment) do
      {:ok, {mode, [src]}} -> do_render(assigns, mode, src)
      :error -> do_render_invalid(assigns)
    end
  end

  defp do_render(assigns, mode, src) do
    ~H"""
    <p
      id="file-attachment-{{ @attachment.rowid }}"
      class="attachment"
    >

      Mode: {{ mode }}
      <Thumbnail
        src={{ src }}
        alt={{ LocalAttachments.alt_name(@attachment) }}
        media_type={{ LocalAttachments.media_type(@attachment) }}
      />
    </p>
    """
  end

  defp do_render_invalid(assigns) do
    reason = if is_nil(assigns.attachment.filename), do: "nil filename", else: "no file"

    ~H"""
    <p
      id="file-attachment-{{ @attachment.rowid }}"
      class="attachment"
    >
      <pre>
        [ATTACHMENT: {{ reason }}]
        {{ inspect(display_attachment(@attachment), pretty: true, limit: :infinity) }}
      </pre>
    </p>
    """
  end

  def display_attachment(attachment) do
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
    ])
  end

  # IO.inspect("""
  # #{IO.ANSI.red()}
  # Attachment MAY be unclear"

  # #{IO.ANSI.yellow()}
  # PATH: #{inspect(path)}

  # #{IO.ANSI.cyan()}
  # #{inspect(attachment)}
  # """)
end
