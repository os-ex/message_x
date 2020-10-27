defmodule MessageXWeb.Components.ChatSidebarItem do
  @moduledoc """
  ChatSidebarItem component.

  ## Examples
  ```
  <ChatSidebarItem form="user" field="birthday" opts={{ autofocus: "autofocus" }}>
  ```
  """

  use MessageXWeb, :surface_component

  prop chat, :map, required: true

  def render(assigns) do
    ~H"""
    <li class="open unread"
        phx-click="show_chat_messages"
        phx-value-chat_id="{{ @chat.rowid }}"
      >

      <div class="card">
        <div class="card-image">
          <figure class="image is-4by3"> <img src="https://source.unsplash.com/random/800x600" alt="Image"> </figure>
        </div>
        <div class="card-content">
          <div class="media">
            <div class="media-left">
              <figure class="image" style="height: 40px; width: 40px;"> <img src="https://source.unsplash.com/random/96x96" alt="Image"> </figure>
            </div>
            <div class="media-content">
              <p class="title is-4">John Smith</p>
              <p class="subtitle is-6">@johnsmith</p>
            </div>
          </div>
          <div class="content"> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus nec iaculis mauris.
            <a>@bulmaio</a>.
            <a>#css</a>
            <a>#responsive</a>
            <br> <small>11:09 PM - 1 Jan 2016</small> </div>
        </div>
      </div>

      <div class="box">
        <article class="media">
          <div class="media-left">
            <figure class="image is-64x64"> <img alt="Image" src="https://s3.amazonaws.com/uifaces/faces/twitter/zeldman/128.jpg">
            </figure>
          </div>
          <div class="media-content">
            <div class="content">
              <p> <strong> John Smith </strong> <small> @johnsmith </small> <small> 31m </small>
                <br> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean efficitur sit amet massa fringilla egestas. Nullam condimentum luctus turpis.
              </p>
            </div>
            <nav class="level">
              <div class="level-left">
                <a class="level-item">
                  <span class="icon is-small"> <i class="fa fa-reply"> </i> </span>
                </a>
                <a class="level-item">
                  <span class="icon is-small"> <i class="fa fa-retweet"> </i> </span>
                </a>
                <a class="level-item">
                  <span class="icon is-small"> <i class="fa fa-heart"> </i> </span>
                </a>
              </div>
            </nav>
          </div>
        </article>
      </div>

      <div class="img">
        {{ img_for_handle @chat.handles }}
        <span class="initials">{{ initials_for(@chat) }}</span>
      </div>
      <div>
        <Components.Timestamp datetime={{ @chat.last_read_message_timestamp }} />
        <p class="name">{{ handle_names_for(@chat) }}</p>
        <p class="preview">{{ preview_text @chat  }} </p>
        <p>{{ length(contacts_for(@chat)) }}</p>
      </div>
    </li>
    """
  end
end
