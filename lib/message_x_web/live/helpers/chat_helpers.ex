defmodule MessageXWeb.ChatHelpers do
  @moduledoc """
  Helpers for `MessageX.Chats.Chat`.
  """

  use Phoenix.HTML

  # alias MessageX.Chats
  alias MessageX.Chats.Chat
  alias MessageX.Messaging
  # alias MessageX.Chats.Message
  alias MessageX.Chats.Handle

  # @impl true
  def img_for_handle(_) do
    # """
    # <img src="//placekitten.com/g/100/100" alt="" />
    # """
    tag(:img, src: "//placekitten.com/g/100/100", alt: "")
  end

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

  def img_for_handle(_) do
    # """
    # <img src="//placekitten.com/g/100/100" alt="" />
    # """
    tag(:img, src: "//placekitten.com/g/100/100", alt: "")
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
      Messaging.find_contact(handle) || %{identifier_name: handle.rowid, photos: []}
    end
  end
end
