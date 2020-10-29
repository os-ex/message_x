defmodule MessageXWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `MessageXWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, MessageXWeb.HandleLive.FormComponent,
        id: @handle.id || :new,
        action: @live_action,
        handle: @handle,
        return_to: Routes.handle_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, MessageXWeb.ModalComponent, modal_opts)
  end

  # def phx_value_attrs(map) when is_map(map) do
  #   for {k, v} <- map, into: %{} do
  #     {:"phx-value-#{k}", v}
  #   end
  # end
end
