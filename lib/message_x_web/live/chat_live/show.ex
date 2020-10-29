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
    socket =
      socket
      |> assign_new(:actor, fn -> get_actor(session) end)
      |> assign_new(:loading, fn -> false end)
      |> assign_new(:chat_id, fn -> nil end)
      |> assign_new(:current_chat, fn -> nil end)
      |> assign_new(:current_messages, fn -> [] end)
      |> keep_live(
        :chats,
        &Chats.Api.list_chats_paginated(&1, &2, params),
        api: Chats.Api,
        results: :keep,
        refetch?: false,
        # refetch_interval: :timer.minutes(1),
        # refetch_window: :timer.minutes(1),
        subscribe: [
          # "user:updated:#{socket.assigns.actor.id}",
          # "chat:updated:#{socket.assigns.actor.id}"
        ]
      )

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

  @impl true
  def handle_event("nav", %{"chat_page" => target}, socket) do
    IO.inspect([:chat_page, target])
    socket = change_page(socket, :chats, target)

    socket =
      socket
      |> push_patch(
        to:
          Routes.chat_show_path(socket, :show, socket.assigns.chat_id,
            chat_page: page_params(socket.assigns.chats)
          )
        # to: Routes.live_path(socket, __MODULE__, chat_page: page_params(socket.assigns.chats))
        # to: Routes.page_path(socket, __MODULE__, chat_page: page_params(socket.assigns.chats))
      )

    {:noreply, socket}
  end

  def handle_event("nav", %{"messages_page" => target}, socket) do
    IO.inspect([:messages_page, target])
    socket = change_page(socket, :current_messages, target)

    socket =
      socket
      |> push_patch(
        to:
          Routes.chat_show_path(socket, :show, socket.assigns.chat_id,
            messages_page: page_params(socket.assigns.current_messages)
          )
      )

    {:noreply, socket}
  end

  # @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    # IO.inspect(handle_params: params)
    IO.inspect(handle_params: params)

    # page_opts = nil

    # socket =
    #   socket
    #   |> assign(:current_chat, Chats.Api.get_current_chat(socket, page_opts, params))

    # {:noreply, socket}
    # # current_chat = Chats.get_chat!(id)

    # # current_messages = Chats.list_chat_messages(current_chat)

    # # # IO.inspect(current_chat: current_chat)
    # # # IO.inspect(current_messages: current_messages)

    # # {
    # #   :noreply,
    # #   socket
    # #   |> assign(:page_title, "Listing Chats")
    # #   |> assign(:chat_id, id)
    # #   |> assign(:chat_params, params)
    # #   |> assign(:current_chat, current_chat)
    # #   |> assign(:current_messages, current_messages)
    # #   #  |> assign(:page_title, page_title(socket.assigns.live_action))
    # #   #  |> assign(:chat, Chats.get_chat!(id))}
    # # }

    socket =
      socket
      |> assign(:chat_id, id)
      |> keep_live(
        :current_chat,
        &Chats.Api.get_current_chat(&1, &2, params),
        api: Chats.Api,
        results: :keep,
        refetch?: false,
        # refetch_interval: :timer.minutes(1),
        # refetch_window: :timer.minutes(1),
        subscribe: [
          # "user:updated:#{socket.assigns.actor.id}",
          # "chat:updated:#{socket.assigns.actor.id}"
        ]
      )
      |> keep_live(
        :current_messages,
        &Chats.Api.list_messages_paginated(&1, &2, params),
        api: Chats.Api,
        refetch?: false,
        results: :keep,
        # refetch_interval: :timer.minutes(1),
        # refetch_window: :timer.minutes(1),
        subscribe: [
          # "user:updated:#{socket.assigns.actor.id}",
          # "chat:updated:#{socket.assigns.actor.id}"
        ]
      )

    {:noreply, socket}
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
end
