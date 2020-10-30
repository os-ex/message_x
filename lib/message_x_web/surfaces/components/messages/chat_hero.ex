defmodule MessageXWeb.Components.ChatHero do
  @moduledoc """
  ChatHero component.
  """

  use MessageXWeb, :surface_component

  alias MessageXWeb.Components.Statistics

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
    <Statistics
      title="Chats"
      size="small"
      color="primary"
      items={{ [
          %{title: "Count",
              value: assigns.chats  |> length(),
            },
            %{title: "Offset",
              value: assigns.chats_meta.limit + assigns.chats_meta.offset,
            },
            %{title: "Total",
              value: assigns.chats_meta.count,
           }
      ] }}

          />
          <Statistics
          size="small"
          color="info"
            title="Messages"
            items={{ [


          %{title: "Count",
              value: assigns.messages  |> length(),
            },
            %{title: "Offset",
              value: assigns.messages_meta.limit + assigns.messages_meta.offset,
            },
            %{title: "Total",
              value: assigns.messages_meta.count,
           }
          ] }}
          />
          <Statistics
          size="small"
          color="success"
            title="Attachments"
            items={{ [


          %{title: "Count",
              value: assigns.messages  |> attachments() |> length(),
            },
            %{title: "No Filename",
              value: assigns.messages  |> attachments() |> Enum.filter(& &1.filename == nil) |> length(),
            },
            %{title: "Hidden",
              value: assigns.messages  |> attachments() |> Enum.filter(& &1.hide_attachment == 0) |> length(),
           }
          ] }}
          />
          <Statistics
          size="small"
          color="warning"
            title="Handles"
            items={{ [


          %{title: "Count",
              value: assigns.chat |> handles() |> length(),
            },
          ] }}
          />
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
