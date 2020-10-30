defmodule MessageXWeb.ChatLive.Show do
  use MessageXWeb, :live_view

  import Ash.Notifier.LiveView
  alias MessageXWeb.PaginationHelpers

  alias MessageX.Chats.Api

  @opts [
    api: Api,
    results: :keep,
    refetch?: false
    # refetch_interval: :timer.minutes(1),
    # refetch_window: :timer.minutes(1),
  ]
  @messages_opts @opts ++
                   [
                     subscribe: [
                       # "user:updated:#{socket.assigns.actor.id}",
                       # "chat:updated:#{socket.assigns.actor.id}"
                     ]
                   ]

  @impl true
  def mount(params, session, socket) do
    socket =
      socket
      |> assign_new(:actor, fn -> FakeUser.refetch_user(session) end)
      |> keep_live(:chat, &Api.get_chat(&1, &2, params), @opts)
      |> keep_live(:chats, &Api.list_chats(&1, &2, params), @opts)
      |> keep_live(:messages, &Api.list_messages(&1, &2, params), @messages_opts)

    {:ok, socket}
  end

  @doc """
  Handle events
  """
  @impl true
  def handle_event("load-more", %{"chat_page" => _target}, socket) do
    {:noreply, PaginationHelpers.scroll_next(socket, :chats)}
  end

  def handle_event("load-more", %{"messages_page" => _target}, socket) do
    {:noreply, PaginationHelpers.scroll_next(socket, :messages)}
  end

  @doc """
  Handle params
  """
  @impl true
  def handle_params(%{"id" => chat_id} = _params, _, socket) when is_binary(chat_id) do
    # IO.inspect(handle_params: params)
    {:noreply, socket}
  end

  def handle_params(_, _, socket), do: {:noreply, socket}

  @doc """
  Render method
  """
  @impl true
  def render(assigns) do
    {messages, filtered_messages} =
      Enum.split_with(assigns.messages.results, &MessageHelpers.renderable?/1)

    if filtered_messages != [] do
      IO.inspect(filtered_messages, pretty: true, limit: :infinity)
    end

    ~L"""
    <%= live_component(@socket, Scenes.Messages,
      chat: @chat,
      chats: @chats.results,
      messages: messages,
      filtered_messages: filtered_messages,
      chats_meta: @chats,
      messages_meta: @messages
      )
    %>
    """
  end
end
