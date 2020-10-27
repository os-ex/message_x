defmodule MessageX.Factories.Factory do
  @moduledoc """
  Factory
  """

  # use ExMachina.Ecto, repo: MessageX.Repo
  use ExMachina.Ecto, repo: MessageX.Repo
  # use ExMachina.ExMachinaCustomEcto, repo: MessageX.Repo

  use MessageX.Factories.Chats.AttachmentFactory
  use MessageX.Factories.Chats.ChatHandleFactory
  use MessageX.Factories.Chats.ChatMessageFactory
  use MessageX.Factories.Chats.ChatFactory
  use MessageX.Factories.Chats.HandleFactory
  use MessageX.Factories.Chats.MessageAttachmentFactory
  use MessageX.Factories.Chats.MessageFactory
end
