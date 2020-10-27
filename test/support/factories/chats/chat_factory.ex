defmodule MessageX.Factories.Chats.ChatFactory do
  @moduledoc """
  Factory for `MessageX.Chats.Chat` structs.
  """

  alias MessageX.Support.Randoms

  alias MessageX.Chats.Chat

  defmacro __using__(_opts) do
    quote do
      def chat_create_mutation_factory do
        %{
          account_id: Randoms.random(:account_id, :string),
          account_login: Randoms.random(:account_login, :string),
          chat_identifier: Randoms.random(:chat_identifier, :string),
          display_name: Randoms.random(:display_name, :string),
          group_id: Randoms.random(:group_id, :string),
          guid: Randoms.random(:guid, :string),
          is_archived: Randoms.random(:boolean_int),
          is_filtered: Randoms.random(:boolean_int),
          last_addressed_handle: Randoms.random(:last_addressed_handle, :string),
          # # properties: Randoms.random(:properties, :binary),
          room_name: Randoms.random(:room_name, :string),
          service_name: Randoms.random(:service_name, :string),
          state: Randoms.random(:state, :integer),
          style: Randoms.random(:style, :integer),
          successful_query: Randoms.random(:successful_query, :integer)
        }
      end

      def chat_factory do
        build(:random_chat)
      end

      def random_chat_factory do
        %Chat{
          account_id: Randoms.random(:account_id, :string),
          account_login: Randoms.random(:account_login, :string),
          chat_identifier: Randoms.random(:chat_identifier, :string),
          display_name: Randoms.random(:display_name, :string),
          group_id: Randoms.random(:group_id, :string),
          guid: Randoms.random(:guid, :string),
          is_archived: Randoms.random(:boolean_int),
          is_filtered: Randoms.random(:boolean_int),
          last_addressed_handle: Randoms.random(:last_addressed_handle, :string),
          # # properties: Randoms.random(:properties, :binary),
          room_name: Randoms.random(:room_name, :string),
          service_name: Randoms.random(:service_name, :string),
          state: Randoms.random(:state, :integer),
          style: Randoms.random(:style, :integer),
          successful_query: Randoms.random(:boolean_int)
        }
      end

      def random_chat_with_assocs_factory do
        build(:random_chat, [])
      end
    end
  end
end
