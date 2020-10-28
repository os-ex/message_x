defmodule MessageXWeb.ChatLive.SidebarItemComponent do
  use MessageXWeb, :live_component

  import MessageXWeb.ChatHelpers
  import MessageXWeb.MessageHelpers

  # alias MessageX.Chats
  # alias MessageX.Chats.Chat
  # alias MessageX.Messaging
  # # alias MessageX.Chats.Message
  # alias MessageX.Chats.Handle

  # @impl true
  # def update(%{chat: chat} = assigns, socket) do
  #   changeset = Chats.change_chat(chat)

  #   {:ok,
  #    socket
  #    |> assign(assigns)
  #    |> assign(:changeset, changeset)}
  # end

  # @impl true
  # def handle_event("validate", %{"chat" => chat_params}, socket) do
  #   changeset =
  #     socket.assigns.chat
  #     |> Chats.change_chat(chat_params)
  #     |> Map.put(:action, :validate)

  #   {:noreply, assign(socket, :changeset, changeset)}
  # end

  # def handle_event("save", %{"chat" => chat_params}, socket) do
  #   save_chat(socket, socket.assigns.action, chat_params)
  # end

  # defp save_chat(socket, :edit, chat_params) do
  #   case Chats.update_chat(socket.assigns.chat, chat_params) do
  #     {:ok, _chat} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Chat updated successfully")
  #        |> push_redirect(to: socket.assigns.return_to)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, :changeset, changeset)}
  #   end
  # end

  # defp save_chat(socket, :new, chat_params) do
  #   case Chats.create_chat(chat_params) do
  #     {:ok, _chat} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Chat created successfully")
  #        |> push_redirect(to: socket.assigns.return_to)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, changeset: changeset)}
  #   end
  # end
end
