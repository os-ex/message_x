defmodule MessageXWeb.Components.FileAttachment do
  @moduledoc """
  FileAttachment component.
  """

  use MessageXWeb, :surface_component

  prop attachment, :map, required: true

  def render(assigns) do
    ~H"""
    <p
      id="file-attachment-{{ @attachment.rowid }}"
      class="attachment"
    >
      {{ AttachmentHelpers.render_attachment(@attachment) }}
    </p>
    """
  end
end
