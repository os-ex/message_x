defmodule MessageXWeb.Components.FileAttachment do
  @moduledoc """
  FileAttachment component.
  """

  use MessageXWeb, :surface_component
  import MessageXWeb.AttachmentHelpers

  prop attachment, :map, required: true

  def render(assigns) do
    ~H"""
    <p
      id="file-attachment-{{ @attachment.rowid }}"
      class="attachment"
    >
      {{ render_attachment(@attachment) }}
    </p>
    """
  end
end
