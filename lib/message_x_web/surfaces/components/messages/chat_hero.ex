defmodule MessageXWeb.Components.ChatHero do
  @moduledoc """
  ChatHero component.
  """

  use MessageXWeb, :surface_component

  alias MessageXWeb.Components.Statistic

  prop chats, :list, required: true, default: []
  prop chat, :map
  prop messages, :list, default: []
  prop filtered_messages, :list, default: []
  prop chats_meta, :map, required: true
  prop messages_meta, :map, required: true

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <div class="hero is-small is-primary">
      <div class="hero-body">
        <div class="container">
          <h1 class="title">
            Chats
          </h1>
          <nav class="level">
            <Statistic
              title="Count"
              value={{ @chats  |> length() }}
            />
            <Statistic
              title="Offset"
              value={{ @chats_meta.limit + @chats_meta.offset }}
            />
            <Statistic
              title="Total"
              value={{ @chats_meta.count }}
            />
          </nav>
        </div>
      </div>
    </div>
    <div class="hero is-small is-info">
      <div class="hero-body">
        <div class="container">
          <h1 class="title">
            Messages
          </h1>
          <nav class="level">
            <Statistic
              title="Count"
              value={{ @messages  |> length() }}
            />
            <Statistic
              title="Offset"
              value={{ @messages_meta.limit + @messages_meta.offset }}
            />
            <Statistic
              title="Total"
              value={{ @messages_meta.count }}
            />
          </nav>
        </div>
      </div>
    </div>
    <div class="hero is-small is-success">
      <div class="hero-body">
        <div class="container">
          <h1 class="title">
            Attachments
          </h1>
          <nav class="level">
            <Statistic
              title="Count"
              value={{ @messages  |> attachments() |> length() }}
            />
            <Statistic
              title="No Filename"
              value={{ @messages  |> attachments() |> Enum.filter(& &1.filename == nil) |> length() }}
            />
            <Statistic
              title="Hidden"
              value={{ @messages  |> attachments() |> Enum.filter(& &1.hide_attachment == 0) |> length() }}
            />
          </nav>
        </div>
      </div>
    </div>
    <div class="hero is-small is-warning">
      <div class="hero-body">
        <div class="container">
          <h1 class="title">
            Handles
          </h1>
          <nav class="level">
            <Statistic
              title="Count"
              value={{ @chat |> handles() |> length() }}
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
    </div>
    """

    # <pre :if={{ @filtered_messages != [] }}>
    #   Filtered: {{ @filtered_messages |> inspect(pretty: true) }}
    # </pre>
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
