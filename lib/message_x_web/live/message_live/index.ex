defmodule MessageXWeb.MessageLive.Index do
  # use MessageXWeb, :live_view
  use MessageXWeb, :live_component

  alias MessageX.Chats
  alias MessageX.Chats.Message

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page: 1, per_page: 100)
      |> assign(metadata: nil)
      |> fetch()

    {:ok, socket, temporary_assigns: [messages: []]}
  end

  defp fetch(%{assigns: %{metadata: nil}} = socket) do
    %{entries: entries, metadata: metadata} = Chats.paginate_messages(:init, nil)

    socket
    |> assign(:messages, entries)
    |> assign(:metadata, metadata)
  end

  defp fetch(%{assigns: %{metadata: metadata}} = socket) do
    %{entries: entries, metadata: metadata} = Chats.paginate_messages(:after, metadata)

    socket
    |> assign(:messages, entries)
    |> assign(:metadata, metadata)
  end

  # defp fetch(%{assigns: %{page: page, per_page: per}} = socket) do
  #   assign(socket, :messages, list_messages(page, per))
  # end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Message")
    |> assign(:message, Chats.get_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Message")
    |> assign(:message, %Message{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Messages")
    |> assign(:message, nil)
  end

  @impl true
  def handle_event("load-more", _, %{assigns: assigns} = socket) do
    {:noreply, socket |> assign(page: assigns.page + 1) |> fetch()}
  end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   message = Chats.get_message!(id)
  #   {:ok, _} = Chats.delete_message(message)

  #   {:noreply, assign(socket, :messages, list_messages(page, per))}
  # end

  defp list_messages(page, per) do
    # Chats.list_messages(page, per)
    []
  end
end
