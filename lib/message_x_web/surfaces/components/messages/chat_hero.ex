defmodule MessageXWeb.Components.ChatHero do
  @moduledoc """
  ChatHero component.
  """

  use MessageXWeb, :surface_component

  alias MessageXWeb.Components.Statistic

  prop loading, :boolean, default: false
  prop chats, :list, required: true, default: []
  prop current_chat, :map
  prop current_messages, :list, default: []
  prop chats_meta, :map, required: true
  prop messages_meta, :map, required: true

  def render(assigns) do
    ~H"""
    <div class="hero is-info">
      <div class="hero-body">
        <nav class="level">
          <Statistic
            title="Messages"
            value={{ @current_messages  |> length() }}
          />
          <Statistic
            title="Messages"
            value={{ @messages_meta.limit + @messages_meta.offset }}
          />
          <Statistic
            title="Messages"
            subtitle="Total"
            value={{ @messages_meta.count }}
          />
          <Statistic
            title="Attachments"
            value={{ @current_messages  |> attachments() |> length() }}
          />
          <Statistic
            title="Attachments"
            subtitle="no filename"
            value={{ @current_messages  |> attachments() |> Enum.filter(& &1.filename == nil) |> length() }}
          />
          <Statistic
            title="Attachments"
            subtitle="hide_attachment"
            value={{ @current_messages  |> attachments() |> Enum.filter(& &1.hide_attachment == 0) |> length() }}
          />
          <Statistic
            title="Handles"
            value={{ @current_chat |> handles() |> length() }}
          />
          <Statistic
            title="Sentiment"
            value={{ 0 }}
          />
          <Statistic
            title="Chats"
            value={{ length(@chats) }}
          />
          <Statistic
            title="Chats"
            subtitle="total"
            value={{ @chats_meta.count }}
          />
        </nav>
      </div>
    </div>
    """
  end

  defp attachments(%{messages: messages}) when is_list(messages) do
    Enum.flat_map(messages, &attachments/1)
  end

  defp attachments(messages) when is_list(messages) do
    Enum.flat_map(messages, &attachments/1)
  end

  defp attachments(%{attachments: attachments}) when is_list(attachments) do
    attachments
  end

  defp attachments(_) do
    []
  end

  defp handles(%{handles: handles}) when is_list(handles), do: handles
  defp handles(_), do: []
end
