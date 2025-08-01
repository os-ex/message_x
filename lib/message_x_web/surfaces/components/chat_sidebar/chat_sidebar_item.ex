defmodule MessageXWeb.Components.ChatSidebarItem do
  @moduledoc """
  ChatSidebarItem component.
  """

  use MessageXWeb, :surface_component

  prop id, :string
  prop chat, :map, required: true

  def render_left(assigns) do
    ~H"""
    <figure class="media-left">
      <p class="image is-64x64">
        {{ ChatHelpers.img_for_handle(@chat.handles) }}
      </p>

      <span class="initials">
        initials
        {{ ChatHelpers.initials_for(@chat) }}
      </span>
    </figure>
    """
  end

  def render_right(assigns) do
    ~H"""
    <div class="media-right">
      <small>
        <Components.Timestamp
          datetime={{ @chat.last_read_message_timestamp || DarkMatter.DateTimes.now!() }}
        />
      </small>
      <br>

      <div>
        <span class="tag is-primary is-light">Messages {{  @chat |> ChatHelpers.messages_for() |> length() }}</span>
        <span class="tag is-primary is-light">Contacts {{  @chat |> ChatHelpers.contacts_for() |> length() }}</span>
      </div>

    </div>
    """
  end

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <article
      id={{ @id || "chat-sidebar-item-#{@chat.rowid}" }}
      class="media"
    >
      {{ render_left(assigns) }}
      <div class="media-content">
        <div class="content">
          <p>
            <div>
              <strong class="chat-sidebar-handle-names">{{ ChatHelpers.handle_names_for(@chat) }}</strong>
            </div>

            <p class="preview">{{ MessageHelpers.preview_text(@chat)  }} </p>
          </p>
        </div>
      </div>
      {{ render_right(assigns) }}
    </article>
    """
  end

  # def render(assigns) do
  #   ~H"""
  #   <li class="open unread"
  #       phx-click="show_chat_messages"
  #       phx-value-chat_id="{{ @chat.rowid }}"
  #     >

  #     <div class="card">
  #       <div class="card-image">
  #         <figure class="image is-4by3"> <img src="https://source.unsplash.com/random/800x600" alt="Image"> </figure>
  #       </div>
  #       <div class="card-content">
  #         <div class="media">
  #           <div class="media-left">
  #             <figure class="image" style="height: 40px; width: 40px;"> <img src="https://source.unsplash.com/random/96x96" alt="Image"> </figure>
  #           </div>
  #           <div class="media-content">
  #             <p class="title is-4">John Smith</p>
  #             <p class="subtitle is-6">@johnsmith</p>
  #           </div>
  #         </div>
  #         <div class="content"> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus nec iaculis mauris.
  #           <a>@bulmaio</a>.
  #           <a>#css</a>
  #           <a>#responsive</a>
  #           <br> <small>11:09 PM - 1 Jan 2016</small> </div>
  #       </div>
  #     </div>

  #     <div class="img">
  #       {{ img_for_handle @chat.handles }}
  #       <span class="initials">{{ initials_for(@chat) }}</span>
  #     </div>
  #     <div>
  #       <Components.Timestamp datetime={{ @chat.last_read_message_timestamp }} />
  #       <p class="name">{{ handle_names_for(@chat) }}</p>
  #       <p class="preview">{{ preview_text @chat  }} </p>
  #       <p>{{ length(contacts_for(@chat)) }}</p>
  #     </div>
  #   </li>
  #   """
  # end

  # def handle_event("chat-sidebar-click", params, socket) do
  #   route = Routes.chat_show_path(socket, :show, socket.assigns.chat)
  #   {:noreply, redirect(socket, to: route)}
  # end
end
