defmodule MessageX.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Supervisor.Spec

  def start(_type, _args) do
    children =
      [
        # Start the Ecto repository
        MessageX.Repo,
        # Start the Telemetry supervisor
        MessageXWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: MessageX.PubSub},
        # Start the Endpoint (http/https)
        MessageXWeb.Endpoint
        # Start a worker by calling: MessageX.Worker.start_link(arg)
        # {MessageX.Worker, arg}
      ] ++ imessage_specs()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MessageX.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MessageXWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def imessage_specs do
    [
      MessageXWeb.Presence,
      {MessageX.Messaging, [name: MessageX.Messaging]}
      # worker(Sqlitex.Server, [
      #   Application.get_env(:imessagex, :chat_db_path),
      #   [name: MessageX.IMessageChatDB]
      # ])
    ]
  end
end
