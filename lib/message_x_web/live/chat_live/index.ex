defmodule MessageXWeb.ChatLive.Index do
  use MessageXWeb, :live_view

  alias MessageX.Chats
  alias MessageX.Chats.Chat
  alias MessageX.Chats.Message

  import Ash.Notifier.LiveView

  alias MessageXWeb.Endpoint
  alias MessageXWeb.Presence

  defp topic(chat_id), do: "chat:#{chat_id}"

  @impl true
  def mount(params, session, socket) do
    actor = get_actor(session)

    socket =
      socket
      |> assign_new(:actor, fn -> actor end)
      |> assign_new(:loading, fn -> false end)

    socket =
      socket
      |> keep_live(
        :me,
        &get_chats/1,
        refetch_interval: :timer.minutes(5),
        subscribe: [
          # "chat:assigned_to:#{socket.assigns.actor.id}"
        ]
      )
      |> keep_live(
        :current_chat,
        &get_current_chat(&1, &2, params),
        api: Chats.Api,
        results: :keep,
        refetch_interval: :timer.minutes(1),
        subscribe: [
          # "user:updated:#{socket.assigns.actor.id}",
          # "chat:updated:#{socket.assigns.actor.id}"
        ]
      )
      |> keep_live(
        :chats,
        &get_chats_paginated(&1, &2, params),
        api: Chats.Api,
        results: :keep,
        refetch_interval: :timer.minutes(1),
        subscribe: [
          # "user:updated:#{socket.assigns.actor.id}",
          # "chat:updated:#{socket.assigns.actor.id}"
        ]
      )
      |> keep_live(
        :current_messages,
        &get_current_messages(&1, &2, params),
        api: Chats.Api,
        results: :keep,
        refetch_interval: :timer.minutes(1),
        subscribe: [
          # "user:updated:#{socket.assigns.actor.id}",
          # "chat:updated:#{socket.assigns.actor.id}"
        ]
      )

    {:ok, socket}
  end

  @impl true
  def handle_params(_, _, socket), do: {:noreply, socket}

  @impl true
  def handle_event("nav", %{"page" => target}, socket) do
    socket = change_page(socket, :chats, target)

    socket =
      socket
      |> push_patch(
        to: Routes.live_path(socket, __MODULE__, page: page_params(socket.assigns.chats))
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{topic: topic, payload: %Ash.Notifier.Notification{}}, socket) do
    {:noreply, handle_live(socket, topic, [:me, :chats])}
  end

  def handle_info({:refetch, assign, opts}, socket) do
    {:noreply, handle_live(socket, :refetch, assign, opts)}
  end

  def get_actor(session) do
    MessageXWeb.Plugs.FakeUser.refetch_user(session)
  end

  def get_chats(socket) do
    # Chats.Message
    # |> Ash.Query.load(:open_chat_count)
    # |> Chats.Api.read_one!(action: :me, actor: socket.assigns.actor)

    page_opts = %{}
    params = %{}

    [
      get_current_chat(socket, page_opts, params)
    ]
  end

  def get_current_chat(socket, page_opts, params) do
    %Chat{id: 1}
    |> Map.merge(%{
      is_online: true,
      last_message_at: 25,
      last_read_message_timestamp: 35,
      handles: [],
      messages: get_current_messages(socket, page_opts, params),
      unread_count: 0,
      identifiers: [],
      avatars: []
    })
  end

  def get_chats_paginated(socket, page_opts, params) do
    # Chats.Chat
    # |> Chats.Api.read!(
    #   action: :assigned,
    #   actor: socket.assigns.actor,
    #   page: page_opts || page_from_params(params["page"], 5, true)
    # )
    get_chats(socket)
  end

  def get_current_messages(socket, page_opts, params) do
    # Chats.Chat
    # |> Chats.Api.read!(
    #   action: :assigned,
    #   actor: socket.assigns.actor,
    #   page: page_opts || page_from_params(params["page"], 5, true)
    # )
    [%Message{id: 1, text: "how are you"} |> Map.merge(%{date_delivered: 33})]
  end
end
