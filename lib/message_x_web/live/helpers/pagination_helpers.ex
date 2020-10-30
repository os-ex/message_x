defmodule MessageXWeb.PaginationHelpers do
  @moduledoc """
  Helpers for pagination
  """

  alias Ash.Notifier.LiveView

  def scroll_next(socket, resource) when is_atom(resource) do
    meta = socket.assigns[resource]

    if LiveView.on_page?(meta, LiveView.last_page(meta)) do
      socket
    else
      LiveView.change_page(socket, resource, "next")
    end
  end

  # def push_page(socket, resource, target) do
  #   socket = LiveView.change_page(socket, resource, target)

  #   socket
  #   |> assign(resource, LiveView.page_params(socket.assigns[resource]))
  #   |> push_all_page_patch()
  # end

  # def handle_event("nav", %{"chat_page" => target}, socket) do
  #   IO.inspect([:chat_page, target])
  #   socket = change_page(socket, :chats, target)

  #   chat_page_params = page_params(socket.assigns.chats)

  #   socket =
  #     socket
  #     |> assign(:chat_page_params, chat_page_params)
  #     |> push_all_page_patch()

  #   # |> push_patch(
  #   #   to:
  #   #     Routes.chat_show_path(socket, :show, socket.assigns.chat_id,
  #   #       chat_page: chat_page_params
  #   #     )
  #   #   # to: Routes.live_path(socket, __MODULE__, chat_page: page_params(socket.assigns.chats))
  #   #   # to: Routes.page_path(socket, __MODULE__, chat_page: page_params(socket.assigns.chats))
  #   # )

  #   {:noreply, socket}
  # end

  # def push_all_page_patch(socket) do
  #   opts = [
  #     chat_page: socket.assigns.chat_page_params,
  #     messages_page: socket.assigns.messages_page_params
  #   ]

  #   IO.inspect(opts)

  #   socket
  #   |> push_patch(
  #     to: Routes.chat_show_path(socket, :show, socket.assigns.chat_id, opts)
  #     # to: Routes.live_path(socket, __MODULE__, chat_page: page_params(socket.assigns.chats))
  #     # to: Routes.page_path(socket, __MODULE__, chat_page: page_params(socket.assigns.chats))
  #   )
  # end
end
