defmodule MessageX.ChatThreads do
  @moduledoc """
  The MessageThreads context.
  """

  alias MessageX.Chats.Chat
  alias MessageX.Chats.Handle
  alias MessageX.Chats.Message

  alias DarkEcto.Types.CFAbsoluteTime

  @type t() :: [{Date.t(), messages_by_handle()}]
  @type messages_by_handle() :: [{Handle.t(), [Message.t()]}]

  @nohandle :__NO_HANDLE__
  @date_sorter {:asc, Date}
  @datetime_sorter {:asc, DateTime}

  @spec group_messages(Chat.t()) :: t()
  def group_messages(%Chat{messages: messages}) when is_list(messages) do
    messages
    |> Enum.group_by(&message_date/1)
    |> Enum.map(&group_date_and_messages_by_handles/1)
    |> Enum.sort_by(&elem(&1, 0), @date_sorter)
  end

  @spec group_date_and_messages_by_handles({Date.t(), [Message.t()]}) ::
          {Date.t(), messages_by_handle()}
  def group_date_and_messages_by_handles({%Date{} = date, messages}) when is_list(messages) do
    {date, group_messages_by_handle(messages)}
  end

  @spec group_messages_by_handle([Message.t()]) :: messages_by_handle()
  def group_messages_by_handle(messages) when is_list(messages) do
    {result, acc, prev_handle} =
      for %Message{handle: %Handle{} = handle} = message <-
            Enum.sort_by(messages, &message_datetime/1, @datetime_sorter),
          reduce: {[], [], @nohandle} do
        {result, acc, ^handle} ->
          {result, acc ++ [message], handle}

        {result, acc, prev_handle} ->
          {result ++ [{prev_handle, acc}], [message], handle}
      end

    result
    |> Enum.concat([{prev_handle, acc}])
    |> Enum.reject(&(elem(&1, 0) == @nohandle))
    |> Enum.reject(&(elem(&1, 1) == []))
  end

  @spec message_date(Message.t()) :: Date.t()
  def message_date(%Message{} = message) do
    message
    |> message_datetime()
    |> DateTime.to_date()
  end

  @spec message_datetime(Message.t()) :: DateTime.t()
  def message_datetime(%Message{date: unix_timestamp}) when is_integer(unix_timestamp) do
    cf_abs_time_to_datetime(unix_timestamp)
  end

  def message_datetime(%Message{date: %DateTime{} = datetime}) do
    datetime
  end

  @spec cf_abs_time_to_datetime(integer()) :: DateTime.t()
  def cf_abs_time_to_datetime(unix_timestamp) when is_integer(unix_timestamp) do
    {:ok, %DateTime{} = datetime} = CFAbsoluteTime.load(unix_timestamp)
    datetime
  end

  @spec cf_abs_time_to_date(integer()) :: Date.t()
  def cf_abs_time_to_date(unix_timestamp) when is_integer(unix_timestamp) do
    unix_timestamp
    |> cf_abs_time_to_datetime()
    |> DateTime.to_date()
  end
end
