defmodule MessageXWeb.Router do
  use MessageXWeb, :router
  require AshJsonApi

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MessageXWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MessageXWeb.Plugs.FakeUser
  end

  pipeline :playground do
    plug :accepts, ["html"]
    plug :fetch_session
    plug MessageXWeb.Plugs.FakeUser
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug MessageXWeb.Plugs.FakeUser
  end

  scope "/json_api" do
    pipe_through(:api)

    AshJsonApi.forward("/MessageX", MessageX.MessageX.Api)
  end

  scope "/" do
    pipe_through(:api)

    forward "/gql", Absinthe.Plug, schema: MessageX.Schema
  end

  # scope "/" do
  #   pipe_through(:playground)

  #   forward "/playground",
  #           Absinthe.Plug.GraphiQL,
  #           schema: MessageX.Schema,
  #           interface: :playground
  # end

  scope "/", MessageXWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  scope "/", MessageXWeb do
    pipe_through :browser
    live "/chats", ChatLive.Index, :index
    # live "/chats", ChatLive.Index, :index, layout: {MessageXWeb.LayoutView, :chats}
    live "/chats/new", ChatLive.Index, :new
    live "/chats/:id/edit", ChatLive.Index, :edit

    live "/chats/:id", ChatLive.Show, :show
    live "/chats/:id/show/edit", ChatLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", MessageXWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MessageXWeb.Telemetry
    end
  end
end
