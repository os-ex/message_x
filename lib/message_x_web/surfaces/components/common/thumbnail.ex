defmodule MessageXWeb.Components.Thumbnail do
  @moduledoc """
  Thumbnail component.
  """

  use MessageXWeb, :surface_component

  use Phoenix.HTML

  @media_types [
    "audio",
    "image",
    "video"
  ]

  @style "max-width: 90%; max-height: 200px"

  prop src, :string, required: true
  prop alt, :string, required: true
  prop media_type, :string, values: @media_types, required: true

  @doc """
  Render Component
  """
  def render(%{media_type: "audio", src: src, alt: alt})
      when is_binary(src) and is_binary(alt) do
    content_tag(:audio, src: src, alt: alt, style: @style)
  end

  def render(%{media_type: "image", src: src, alt: alt})
      when is_binary(src) and is_binary(alt) do
    # TODO: responsive images
    # https://hexdocs.pm/phoenix_html/Phoenix.HTML.Tag.html#img_tag/2
    # img_tag("/logo.png", srcset: %{"/logo.png" => "1x", "/logo-2x.png" => "2x"})

    img_tag(src, alt: alt, style: @style)
  end

  def render(%{media_type: "video", src: src, alt: alt})
      when is_binary(src) and is_binary(alt) do
    content_tag(
      :embed,
      src: src,
      alt: alt,
      x: 200,
      y: 200,
      style: @style,
      target: "_blank"
    )
  end
end
