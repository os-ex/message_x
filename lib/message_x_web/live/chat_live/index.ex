defmodule MessageXWeb.ChatLive.Index do
  use MessageXWeb, :live_view

  alias MessageX.Chats

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
      |> assign_new(:current_chat, fn -> nil end)

    # |> assign_new(:current_chat, fn -> %Chat{rowid: -1, messages: []} end)

    # page_opts = %{"page" => 1}
    # params = %{}
    # IO.inspect(result: get_chats_paginated(socket, page_opts, params))

    socket =
      socket
      # |> keep_live(
      #   :current_chat,
      #   &get_current_chat(&1, &2, params),
      #   api: Chats.Api,
      #   results: :keep,
      #   # refetch_interval: :timer.minutes(1),
      #   subscribe: [
      #     # "user:updated:#{socket.assigns.actor.id}",
      #     # "chat:updated:#{socket.assigns.actor.id}"
      #   ]
      # )
      |> keep_live(
        :chats,
        &get_chats_paginated(&1, &2, params),
        api: Chats.Api,
        results: :keep,
        # refetch_interval: :timer.minutes(1),
        subscribe: [
          # "user:updated:#{socket.assigns.actor.id}",
          # "chat:updated:#{socket.assigns.actor.id}"
        ]
      )

    # |> keep_live(
    #   :messages,
    #   &get_messages(&1, &2, params),
    #   api: Chats.Api,
    #   results: :keep,
    #   # refetch_interval: :timer.minutes(1),
    #   subscribe: [
    #     # "user:updated:#{socket.assigns.actor.id}",
    #     # "chat:updated:#{socket.assigns.actor.id}"
    #   ]
    # )

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

  def handle_info({:refetch, assign, opts} = res, socket) do
    IO.inspect(res: res)

    {:noreply, handle_live(socket, :refetch, assign, opts)}
  end

  def get_actor(session) do
    MessageXWeb.Plugs.FakeUser.refetch_user(session)
  end

  # def get_chats(socket) do
  #   MessageX.Chats.Chat
  #   # |> Ash.Query.load(:index)
  #   |> MessageX.Chats.Api.read!(action: :index, actor: socket.assigns.actor,

  #     page: page_opts || page_from_params(params["page"], 5, true)

  #   )

  #   # page_opts = %{}
  #   # params = %{}

  #   # [
  #   #   get_current_chat(socket, page_opts, params)
  #   # ]

  #   # import MessageX.Factories.Factory

  #   # for chat_id <- 1..25 do
  #   #   handles = [build(:handle)]

  #   #   messages =
  #   #     for id <- 1..20 do
  #   #       build(:message, rowid: id, handle: build(:handle), attachments: [])
  #   #     end

  #   #   build(:chat, rowid: chat_id, messages: messages, handles: handles)
  #   # end
  # end

  def get_current_chat(socket, page_opts, params) do
    import MessageX.Factories.Factory

    handles = [build(:handle)]
    messages = get_messages(socket, page_opts, params)
    build(:chat, messages: messages, handles: handles)

    # %Chat{id: 1}
    # |> Map.merge(%{
    #   is_online: true,
    #   last_message_at: 25,
    #   last_read_message_timestamp: 35,
    #   handles: [],
    #   messages: get_messages(socket, page_opts, params),
    #   unread_count: 0,
    #   identifiers: [],
    #   avatars: []
    # })

    %{results: [chat | _]} = get_chats_paginated(socket, page_opts, params)
    chat
  end

  def get_chats_paginated(socket, page_opts, params) do
    result =
      MessageX.Chats.Chat
      |> Ash.Query.sort(rowid: :desc)
      |> Ash.Query.load([
        :handle_last_addressed,
        :handles,
        messages: [
          :handle,
          :handle_of_other,
          :attachments
        ]
        # :messages
        # messages: :attachments
      ])
      # |> Ash.Query.limit(1)
      # |> Ash.Query.limit(3)
      |> MessageX.Chats.Api.read!(
        action: :most_recent,
        # actor: socket.assigns.actor,
        # page: [limit: 1, offset: 0]
        # page: [limit: 1]
        # page: [count: true, limit: 1, offset: 50]
        page: page_opts || page_from_params(params["page"], 10, true)
        # page: page_opts
      )

    # IO.inspect(result, pretty: true)

    result
  end

  # def get_messages2 do
  #   MessageX.Chats.Message
  #   |> Ash.Query.load([
  #     :handle,
  #     :attachments
  #   ])
  #   |> MessageX.Chats.Api.read!(
  #     action: :index,
  #     page: [limit: 1, offset: 0]
  #     # actor: socket.assigns.actor,
  #     # page: [count: true, limit: 5]
  #     # page: page_opts || page_from_params(params["page"], 5, true)
  #     # page: page_opts
  #   )
  # end

  def get_messages(socket, page_opts, params) do
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
  end
end
