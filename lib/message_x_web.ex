defmodule MessageXWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use MessageXWeb, :controller
      use MessageXWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: MessageXWeb

      import Plug.Conn
      import MessageXWeb.Gettext
      alias MessageXWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/message_x_web/templates",
        namespace: MessageXWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {MessageXWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent
      unquote(view_helpers())
    end
  end

  def surface_component do
    quote do
      use Surface.Component
      alias MessageXWeb.Components
      unquote(view_helpers())
      unquote(surface_helpers())
    end
  end

  def surface_live_component do
    quote do
      use Surface.LiveComponent
      alias MessageXWeb.Components
      unquote(view_helpers())
      unquote(surface_helpers())
    end
  end

  def surface_live_view do
    quote do
      use Surface.LiveView
      alias MessageXWeb.Components
      unquote(view_helpers())
      unquote(surface_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import MessageXWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # MessageXWeb Helpers
      import MessageXWeb.LiveHelpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import MessageXWeb.ErrorHelpers
      import MessageXWeb.Gettext
      alias MessageXWeb.Router.Helpers, as: Routes
    end
  end

  defp surface_helpers do
    quote do
      alias MessageXWeb.AttachmentHelpers
      alias MessageXWeb.ChatHelpers
      alias MessageXWeb.MessageHelpers

      alias Surface.Components.Context
      alias Surface.Components.Form
      alias Surface.Components.Form.Checkbox
      alias Surface.Components.Form.ColorInput
      alias Surface.Components.Form.DateInput
      alias Surface.Components.Form.DatetimeLocalInput
      alias Surface.Components.Form.DatetimeSelect
      alias Surface.Components.Form.EmailInput
      alias Surface.Components.Form.Field
      alias Surface.Components.Form.FieldContext
      alias Surface.Components.Form.FileInput
      alias Surface.Components.Form.HiddenInput
      alias Surface.Components.Form.HiddenInputs
      alias Surface.Components.Form.Input
      alias Surface.Components.Form.Inputs
      alias Surface.Components.Form.Label
      alias Surface.Components.Form.MultipleSelect
      alias Surface.Components.Form.NumberInput
      alias Surface.Components.Form.OptionsForSelect
      alias Surface.Components.Form.PasswordInput
      alias Surface.Components.Form.RadioButton
      alias Surface.Components.Form.RangeInput
      alias Surface.Components.Form.Reset
      alias Surface.Components.Form.SearchInput
      alias Surface.Components.Form.Select
      alias Surface.Components.Form.Submit
      alias Surface.Components.Form.TelephoneInput
      alias Surface.Components.Form.TextArea
      alias Surface.Components.Form.TextInput
      alias Surface.Components.Form.TimeInput
      alias Surface.Components.Form.TimeSelect
      alias Surface.Components.Form.UrlInput
      alias Surface.Components.Form.Utils
      alias Surface.Components.Link
      alias Surface.Components.LivePatch
      alias Surface.Components.LiveRedirect
      alias Surface.Components.Markdown

      alias SurfaceBulma.Button
      alias SurfaceBulma.Delete
      alias SurfaceBulma.Table
      alias SurfaceBulma.Table.Column
      alias SurfaceBulma.Tabs
      alias SurfaceBulma.Tabs.TabItem
      alias SurfaceBulma.Tag
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
