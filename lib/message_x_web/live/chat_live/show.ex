defmodule MessageXWeb.ChatLive.Show do
  use MessageXWeb, :live_view

  alias MessageX.Chats
  alias MessageX.Chats.Chat
  alias MessageX.Chats.ChatMessage
  alias MessageX.Chats.Handle
  alias MessageX.Chats.Message

  import Ash.Notifier.LiveView

  alias MessageXWeb.Endpoint
  alias MessageXWeb.Presence

  alias DarkMatter.DateTimes
  require Ash.Query

  defp topic(chat_id), do: "chat:#{chat_id}"

  @impl true
  def mount(params, session, socket) do
    actor = get_actor(session)

    socket =
      socket
      |> assign_new(:actor, fn -> actor end)
      |> assign_new(:loading, fn -> false end)

    # |> assign_new(:current_chat, fn -> nil end)

    # |> assign_new(:current_chat, fn -> %Chat{rowid: -1, messages: []} end)

    # page_opts = %{"page" => 1}
    # params = %{}
    # IO.inspect(result: get_chats_paginated(socket, page_opts, params))

    socket =
      socket
      |> keep_live(
        :current_chat,
        &get_current_chat(&1, &2, params),
        api: Chats.Api,
        results: :keep,
        # refetch_interval: :timer.minutes(1),
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
        # refetch_interval: :timer.minutes(1),
        subscribe: [
          # "user:updated:#{socket.assigns.actor.id}",
          # "chat:updated:#{socket.assigns.actor.id}"
        ]
      )
      |> keep_live(
        :current_chat_messages,
        &get_chat_messages_paginated(&1, &2, params),
        api: Chats.Api,
        results: :keep,
        # refetch_interval: :timer.minutes(1),
        subscribe: [
          # "user:updated:#{socket.assigns.actor.id}",
          # "chat:updated:#{socket.assigns.actor.id}"
        ]
      )

    # |> keep_live(
    #   :current_messages,
    #   &get_current_messages(&1, &2, params),
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

  # @impl true
  # def mount(_params, _session, socket) do
  #   # Presence.track_presence(
  #   #   self(),
  #   #   topic(chat.rowid),
  #   #   current_user.id,
  #   #   default_user_presence_payload(current_user)
  #   # )

  #   # Endpoint.subscribe(topic(chat.rowid))

  #   chats = list_chats()
  #   current_chat = if chats == [], do: nil, else: Enum.at(chats, 0)

  #   current_messages =
  #     if current_chat == nil, do: [], else: Chats.list_chat_messages(current_chat)

  #   socket =
  #     socket
  #     |> assign(:chats, chats)
  #     |> assign(:current_chat, nil)
  #     |> assign(:current_messages, [])

  #   # |> assign(:current_chat, current_chat)
  #   # |> assign(:current_messages, current_messages)

  #   {:ok, socket}
  # end

  # def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{chat: chat}}) do
  #   {:noreply,
  #    assign(socket,
  #      users: Presence.list_presences(topic(chat.rowid))
  #    )}
  # end

  # def handle_event("typing", _value, socket = %{assigns: %{chat: chat, current_user: user}}) do
  #   Presence.update_presence(self(), topic(chat.rowid), user.id, %{typing: true})
  #   {:noreply, socket}
  # end

  # def handle_event(
  #       "stop_typing",
  #       value,
  #       socket = %{assigns: %{chat: chat, current_user: user, message: message}}
  #     ) do
  #   message = Chats.change_message(message, %{content: value})
  #   Presence.update_presence(self(), topic(chat.rowid), user.id, %{typing: false})
  #   {:noreply, assign(socket, message: message)}
  # end

  # defp default_user_presence_payload(user) do
  #   %{
  #     typing: false,
  #     first_name: user.first_name,
  #     email: user.email,
  #     user_id: user.id
  #   }
  # end

  # @impl true
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    IO.inspect(handle_params: params)

    page_opts = nil

    socket =
      socket
      |> assign(:current_chat, get_current_chat(socket, page_opts, params))

    {:noreply, socket}
    # current_chat = Chats.get_chat!(id)

    # current_messages = Chats.list_chat_messages(current_chat)

    # # IO.inspect(current_chat: current_chat)
    # # IO.inspect(current_messages: current_messages)

    # {
    #   :noreply,
    #   socket
    #   |> assign(:page_title, "Listing Chats")
    #   |> assign(:chat_id, id)
    #   |> assign(:chat_params, params)
    #   |> assign(:current_chat, current_chat)
    #   |> assign(:current_messages, current_messages)
    #   #  |> assign(:page_title, page_title(socket.assigns.live_action))
    #   #  |> assign(:chat, Chats.get_chat!(id))}
    # }
  end

  @impl true
  def handle_params(_, _, socket), do: {:noreply, socket}

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Chat")
  #   |> assign(:chat, Chats.get_chat!(id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Chat")
  #   |> assign(:chat, %Chat{})
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Chats")
  #   |> assign(:chat, nil)
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   chat = Chats.get_chat!(id)
  #   {:ok, _} = Chats.delete_chat(chat)

  #   {:noreply, assign(socket, :chats, list_chats())}
  # end

  # def handle_event("show_chat_messages", %{"chat_id" => chat_id} = _params, socket) do
  #   {:noreply, push_redirect(socket, to: Routes.chat_show_path(socket, :show, chat_id))}
  # end

  # defp list_chats do
  #   # Chats.list_chats()
  #   # MessageX.Messaging.chats()

  #   GenServer.call(MessageX.Messaging, :chats)
  # end

  def get_actor(session) do
    MessageXWeb.Plugs.FakeUser.refetch_user(session)
  end

  def get_chats_paginated(socket, page_opts, params) do
    result =
      MessageX.Chats.Chat
      |> Ash.Query.filter(rowid < 1000)
      |> Ash.Query.sort(rowid: :desc)
      |> Ash.Query.load([
        :handle_last_addressed,
        :handles,
        # :messages
        messages: [
          # :handle,
          # :handle_of_other,
          # :attachments
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
        page: page_opts || page_from_params(params["page"], 5, true)
        # page: page_opts
      )

    # IO.inspect(result.results |> Enum.map(& &1.messages), pretty: true)

    result
  end

  def get_chat_messages_paginated(socket, page_opts, params) do
    IO.inspect(params: params)

    chat_id = String.to_integer(params["id"])
    chat_ids = [chat_id]

    result =
      MessageX.Chats.ChatMessage
      |> Ash.Query.filter(chat_id: params["id"])
      |> Ash.Query.sort(message_date: :asc)
      |> Ash.Query.load(
        message: [
          :handle,
          :handle_of_other,
          :attachments
        ]
      )
      |> MessageX.Chats.Api.read!(
        action: :in_chat,
        # filter: [rowid: params["id"]],
        # actor: socket.assigns.actor,
        # page: [count: true, limit: 1, offset: 50]
        page: page_opts || page_from_params(params["page"], 5, true)
        # page: page_opts
      )

    IO.inspect(
      results: result.results |> Enum.map(&{&1.message.rowid, &1.message.handle}),
      pretty: true,
      limit: :infinity
    )

    # %{results: result}
    result
  end

  def get_current_chat(socket, page_opts, params) do
    result =
      MessageX.Chats.Chat
      # |> Ash.Query.load([
      #   :handle_last_addressed,
      #   :handles,
      #   messages: [
      #     :handle,
      #     :handle_of_other,
      #     :attachments
      #   ]
      #   # :messages
      #   # messages: :attachments
      # ])
      # |> Ash.Query.limit(1)
      # |> Ash.Query.limit(3)
      |> MessageX.Chats.Api.get!(
        params["id"],
        load: [
          :handle_last_addressed,
          :handles
          # :messages
          # messages: [
          #   :handle,
          #   # :handle_of_other,
          #   :attachments
          # ]
          # :messages
          # messages: :attachments
        ]
        # params
        # action: :most_recent,
        # actor: socket.assigns.actor,
        # page: [limit: 1, offset: 0]
        # page: [limit: 1]
        # page: [count: true, limit: 1, offset: 50]
        # page: page_opts
      )

    # IO.inspect(result, pretty: true)

    result
  end
end
