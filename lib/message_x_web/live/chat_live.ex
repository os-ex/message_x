defmodule MessageXWeb.HomeLive do
  use MessageXWeb, :live_view
  use Phoenix.HTML

  alias MessageX.Chats
  import Ash.Notifier.LiveView

  @impl true
  def mount(params, session, socket) do
    socket =
      assign_new(socket, :actor, fn ->
        MessageXWeb.Plugs.FakeContact.refetch_user(session)
      end)

    socket =
      socket
      |> keep_live(
        :me,
        fn socket ->
          Chats.Message
          |> Ash.Query.load(:open_chat_count)
          |> Chats.Api.read_one!(action: :me, actor: socket.assigns.actor)
        end,
        refetch_interval: :timer.minutes(5),
        subscribe: [
          "chat:assigned_to:#{socket.assigns.actor.id}"
        ]
      )
      |> keep_live(
        :chats,
        fn socket, page_opts ->
          Chats.Chat
          |> Chats.Api.read!(
            action: :assigned,
            actor: socket.assigns.actor,
            page: page_opts || page_from_params(params["page"], 5, true)
          )
        end,
        api: Chats.Api,
        results: :keep,
        refetch_interval: :timer.minutes(1),
        subscribe: [
          "user:updated:#{socket.assigns.actor.id}",
          "chat:updated:#{socket.assigns.actor.id}"
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
end
