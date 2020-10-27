defmodule MessageXWeb.ChatLive.Index do
  use MessageXWeb, :live_view

  alias MessageX.Chats
  alias MessageX.Chats.Chat
  alias MessageX.Chats.Handle
  alias MessageX.Chats.Message

  import Ash.Notifier.LiveView

  alias MessageXWeb.Endpoint
  alias MessageXWeb.Presence

  alias DarkMatter.DateTimes

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

  # def mount_current_chat(socket) do
  #   keep_live(
  #     socket,
  #     :current_chat,
  #     &get_current_chat(&1, &2, params),
  #     api: Chats.Api,
  #     results: :keep,
  #     refetch_interval: :timer.minutes(1),
  #     subscribe: [
  #       # "user:updated:#{socket.assigns.actor.id}",
  #       # "chat:updated:#{socket.assigns.actor.id}"
  #     ]
  #   )
  # end

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

    # page_opts = %{}
    # params = %{}

    # [
    #   get_current_chat(socket, page_opts, params)
    # ]

    import MessageX.Factories.Factory

    for chat_id <- 1..25 do
      handles = [build(:handle)]

      messages =
        for id <- 1..20 do
          build(:message, rowid: id, handle: build(:handle), attachments: [])
        end

      build(:chat, rowid: chat_id, messages: messages, handles: handles)
    end
  end

  def get_current_chat(socket, page_opts, params) do
    import MessageX.Factories.Factory

    handles = [build(:handle)]
    messages = get_current_messages(socket, page_opts, params)
    build(:chat, messages: messages, handles: handles)

    # %Chat{id: 1}
    # |> Map.merge(%{
    #   is_online: true,
    #   last_message_at: 25,
    #   last_read_message_timestamp: 35,
    #   handles: [],
    #   messages: get_current_messages(socket, page_opts, params),
    #   unread_count: 0,
    #   identifiers: [],
    #   avatars: []
    # })
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
    # handle1 = %Handle{}
    # handle2 = %Handle{}

    import MessageX.Factories.Factory

    for id <- 1..50 do
      build(:message, rowid: id, handle: build(:handle), attachments: [])
    end

    # [
    #   %Message{
    #     id: 1,
    #     text: "how are you1",
    #     date: 35,
    #     date_delivered: 22,
    #     is_from_me: 0,
    #     attachments: [],
    #     handle: handle1
    #   },
    #   %Message{
    #     id: 2,
    #     text: "how are you2",
    #     date: 35,
    #     date_delivered: 23,
    #     is_from_me: 1,
    #     attachments: [],
    #     handle: handle2
    #   },
    #   %Message{
    #     id: 3,
    #     text: "how are you3",
    #     date: 35,
    #     date_delivered: 22,
    #     is_from_me: 0,
    #     attachments: [],
    #     handle: handle1
    #   }
    # ]
  end
end
