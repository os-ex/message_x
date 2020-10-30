defmodule MessageXWeb.ChatLive.Show do
  use MessageXWeb, :live_view

  import Ash.Notifier.LiveView
  require Ash.Query
  alias MessageXWeb.PaginationHelpers

  alias MessageX.Chats.Api

  @opts [
    api: Api,
    results: :keep,
    refetch?: false,
    # refetch_interval: :timer.minutes(1),
    # refetch_window: :timer.minutes(1),
    subscribe: [
      # "user:updated:#{socket.assigns.actor.id}",
      # "chat:updated:#{socket.assigns.actor.id}"
    ]
  ]

  @impl true
  def mount(params, session, socket) do
    chat_id = params["id"]

    socket =
      socket
      |> assign_new(:actor, fn -> get_actor(session) end)
      |> assign_new(:chat_id, fn -> chat_id end)
      |> keep_live(:chats, &Api.list_chats(&1, &2, params), @opts)
      |> keep_live(:current_chat, &Api.get_current_chat(&1, &2, params), @opts)
      |> keep_live(:current_messages, &Api.list_messages(&1, &2, params), @opts)

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
    {:noreply, PaginationHelpers.scroll_next(socket, :current_messages)}
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

  def get_actor(session) do
    MessageXWeb.Plugs.FakeUser.refetch_user(session)
  end

  @doc """
  Render method
  """
  @impl true
  def render(assigns) do
    ~L"""
    <%= live_component(@socket, Scenes.Messages,
      chats_meta: @chats,
      messages_meta: @current_messages,
      chats: @chats.results,
      current_messages: @current_messages.results,
      current_chat: @current_chat
      )
    %>
    """
  end
end
