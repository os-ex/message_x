defmodule MessageXWeb.ChatLive.SidebarItemComponent do
  use MessageXWeb, :live_component

  # alias MessageX.Chats
  alias MessageX.Chats.Chat
  alias MessageX.Messaging
  # alias MessageX.Chats.Message
  alias MessageX.Chats.Handle

  # @impl true
  def img_for_handle([]) do
    # """
    # <img src="//placekitten.com/g/100/100" alt="" />
    # """
    tag(:img, src: "//placekitten.com/g/100/100", alt: "")
  end

  def img_for_handle(handles) when is_list(handles) do
    # ~L"""
    # <img src="<%= Handle.image_url(@chat.handles) %>" alt="" />
    # """

    # """
    # <img src="${Handle.image_url(@chat.handles)}" alt="" />
    # """
    contacts =
      for handle <- handles, contact = Messaging.find_contact(handle) do
        contact
      end

    case contacts do
      [] ->
        nil

      [%{photos: [%{params: %{type: type}, value: value} | _]} | _] ->
        src = "data:image/#{String.downcase(type)};base64,#{value}"
        tag(:img, src: src, alt: "")

      _ ->
        nil
    end

    # tag(:img, src: "//placekitten.com/g/100/100", alt: "")
  end

  def initials_for(%Chat{} = chat) do
    most_recent_contact =
      chat.last_addressed_handle && Messaging.find_contact(chat.last_addressed_handle)

    if most_recent_contact do
      # [most_recent_contact.given_name, most_recent_contact.family_name]
      # |> Enum.reject(&is_nil/1)
      # |> Enum.map(&String.slice(&1, 0..0))
      # |> Enum.join("")
      most_recent_contact.initials
    else
      # chat.last_addressed_handle
      "U"
    end
  end

  def handle_names_for(%Chat{} = chat) do
    names = for contact <- contacts_for(chat), do: contact.identifier_name
    names |> Enum.join(", ")
  end

  def contacts_for(%Chat{} = chat) do
    for handle <- chat.handles do
      Messaging.find_contact(handle) || %{identifier_name: handle.id, photos: []}
    end
  end

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
