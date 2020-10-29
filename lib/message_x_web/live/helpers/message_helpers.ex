defmodule MessageXWeb.MessageHelpers do
  @moduledoc """
  Helpers for `MessageX.Chats.Message`.
  """

  # import Phoenix.LiveView.Helpers

  use Phoenix.HTML

  alias MessageX.Chats.Chat
  alias MessageX.Chats.Handle
  alias MessageX.Chats.Message
  alias MessageX.Messaging

  alias DarkEcto.Types.CFAbsoluteTime

  # relates to message.associated_message_guid

  @reference_verbs %{
    "Laughed" => "😂",
    "Emphasized" => "❗",
    "Loved" => "❤️",
    "Disliked" => "👎",
    "Liked" => "👍",
    # TODO: Not sure about this one
    "Questioned" => "❓"
  }

  @reference_patterns [
    "at an attachment$",
    "at an audio attachment$",
    "at an image$",
    "at a movie$",
    "at “.*”$",
    "at \".*\"$",
    "an attachment$",
    "an audio attachment$",
    "an image$",
    "a movie$",
    "\".*\"$",
    "“.*”$"
  ]

  @reference_substitutions (for {verb, substitution} <- @reference_verbs,
                                pattern <- @reference_patterns do
                              {~r/^#{verb} #{pattern}/, substitution}
                            end)

  def replace_rich_text(binary, :associated_messages) when is_binary(binary) do
    case Enum.find(@reference_substitutions, fn {regex, _substitution} ->
           String.match?(binary, regex)
         end) do
      {regex, substitution} -> String.replace(binary, regex, substitution <> "[@]")
      _ -> binary
    end
  end

  def replace_rich_text("￼", :attachment_references) do
    "[Attachment-only]"
  end

  def replace_rich_text(binary, :attachment_references) when is_binary(binary) do
    binary
    |> String.replace("￼", "[Attachment-substitution]")
  end

  def replace_rich_text(list, :hashtags) when is_list(list) do
    list
  end

  def replace_rich_text(list, :hyperlinks) when is_list(list) do
    for token <- list do
      if is_binary(token) and valid_url?(token) do
        link(token, to: token, target: "_blank")
      else
        token
      end
    end
  end

  def replace_rich_text(list, :youtube_hyperlinks) when is_list(list) do
    list
  end

  def replace_rich_text(list, _) when is_list(list) do
    list
  end

  def rich_text(binary, opts \\ [])

  def rich_text(binary, opts) when is_binary(binary) and is_list(opts) do
    binary
    |> replace_rich_text(:associated_messages)
    |> replace_rich_text(:attachment_references)
    |> String.split(~r/(\s+)/, include_captures: true)
    |> replace_rich_text(:hashtags)
    |> replace_rich_text(:hyperlinks)
    |> replace_rich_text(:youtube_hyperlinks)
  end

  def rich_text(nil, _opts) do
    ""
  end

  def blank?(%Message{text: nil}) do
    true
  end

  def blank?(%Message{text: ""}) do
    true
  end

  def blank?(%Message{text: text}) when is_binary(text) do
    text |> String.replace("￼", "") |> String.trim() == ""
  end

  def sender_name(%Message{handle: handle}) do
    sender_name(handle)
  end

  def sender_name(%Handle{id: id} = handle) do
    case Messaging.find_contact(handle) do
      nil -> id
      %{identifier_number: identifier_number} -> identifier_number
    end
  end

  def sender_name(nil) do
    nil
  end

  def sender_name(_) do
    "UnknownSenderName"
  end

  # def render_time(%DateTime{} = datetime) do
  #   ~L"""
  #   <time datetime="#{datetime_format(datetime)}">
  #     #{relative_datetime_format(datetime)}
  #   </time>
  #   """
  # end

  def preview_text(%Chat{messages: []}) do
    "Start your message..."
  end

  def preview_text(%Chat{messages: messages} = chat) when is_list(messages) do
    messages |> Enum.at(0) |> Map.get(:text) |> rich_text()
  end

  def preview_text(%Chat{}) do
    "Nothing yet..."
  end

  def format_datetime(integer) when is_integer(integer) do
    case CFAbsoluteTime.load(integer) do
      {:ok, %DateTime{} = datetime} ->
        format_datetime(datetime)

      any ->
        IO.inspect(any)
        ""
    end
  end

  def format_datetime(%Date{} = date) do
    datetime_format(date)
  end

  def format_datetime(%DateTime{} = datetime) do
    datetime_format(datetime)
  end

  def relative_datetime_format(datetime) do
    format_datetime(datetime)
  end

  def datetime_format(%DateTime{} = datetime) do
    "#{date_format(datetime)}, #{time_format(datetime)}"
  end

  def datetime_format(%Date{} = date) do
    "#{date_format(date)}"
  end

  @spec time_format(DateTime.t()) :: <<_::32, _::_*8>>
  def time_format(%DateTime{hour: hour, minute: minute}) when hour >= 12 do
    min = String.pad_leading("#{minute}", 2, ["0"])
    "#{hour - 11}:#{min} PM"
  end

  def time_format(%DateTime{hour: hour, minute: minute}) do
    min = String.pad_leading("#{minute}", 2, ["0"])
    "#{hour + 1}:#{min} AM"
  end

  def date_format(%DateTime{} = datetime) do
    "#{datetime.month}/#{datetime.day}/#{datetime.year}"
  end

  def date_format(%Date{} = date) do
    "#{date.month}/#{date.day}/#{date.year}"
  end

  def valid_url?(binary) when is_binary(binary) do
    case URI.parse(binary) do
      %URI{scheme: nil} -> false
      %URI{host: nil} -> false
      %URI{path: nil} -> false
      %URI{scheme: scheme} when scheme not in ["http", "https"] -> false
      uri -> true
    end
  end
end
