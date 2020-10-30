defmodule MessageXWeb.ChatLive.Index do
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
  @chat_opts @opts ++
               [
                 subscribe: [
                   # "chat:updated:#{socket.assigns.actor.id}"
                 ]
               ]

  @impl true
  def mount(params, session, socket) do
    socket =
      socket
      |> assign_new(:actor, fn -> FakeUser.refetch_user(session) end)
      |> keep_live(:chats, &Api.list_chats(&1, &2, params), @chat_opts)

    {:ok, socket}
  end

  @doc """
  Handle events
  """
  @impl true
  def handle_event("load-more", %{"chat_page" => _target}, socket) do
    {:noreply, PaginationHelpers.scroll_next(socket, :chats)}
  end

  @doc """
  Handle params
  """
  @impl true
  def handle_params(_, _, socket), do: {:noreply, socket}

  @doc """
  Render method
  """
  @impl true
  def render(assigns) do
    ~L"""
    <%= live_component(@socket, Scenes.Messages,
      chat: nil,
      chats: @chats.results,
      messages: [],
      filtered_messages: [],
      chats_meta: @chats,
      messages_meta: nil
      )
    %>
    """
  end
end
