defmodule MessageXWeb.MessageLive.Show do
  # use MessageXWeb, :live_view
  use MessageXWeb, :live_component

  alias MessageX.Chats

  import MessageXWeb.AttachmentHelpers
  import MessageXWeb.MessageHelpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:message, Chats.get_message!(id))}
  end

  defp page_title(:show), do: "Show Message"
  defp page_title(:edit), do: "Edit Message"
end
