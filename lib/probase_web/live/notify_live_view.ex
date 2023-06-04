defmodule ProbaseWeb.NotifyLiveView do
    use Phoenix.LiveView
    alias Probase.Notify
    alias ProbaseWeb.Presence
  
  defp live_view_topic(chat_id), do: "chat:#{chat_id}"

  def render(assigns), do: ProbaseWeb.NotifyView.render("notify_messages.html", assigns)

  def mount(_params, %{"user_notify_chat" => chat, "login_users" => current_user, "user_name" => user_name} = session, socket) do
    Presence.track_presence(self(), live_view_topic(chat.id), current_user.id, default_user_presence_payload(current_user))
    ProbaseWeb.Endpoint.subscribe(live_view_topic(chat.id))
    {:ok, socket |> assign(user_name: user_name, chat: chat, message: Notify.change_message(), current_user: current_user, users: Presence.list_presences(live_view_topic(chat.id)), username_colors: username_colors(chat))}
  end 

  def handle_event("new_message", %{"message" => %{"content" => ""}}, socket), do: {:noreply, socket}
  
  def handle_event("new_message", %{"message" => message_params}, socket) do
    chat = Notify.create_message(message_params)
    ProbaseWeb.Endpoint.broadcast(live_view_topic(chat.id), "new_message", %{chat: chat})
    {:noreply, assign(socket, chat: chat, message: Notify.change_message())}
  end

  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{chat: chat}}), do: {:noreply, assign(socket, users: Presence.list_presences(live_view_topic(chat.id)))}

  def handle_info(%{event: "new_message", payload: state}, socket), do: {:noreply, assign(socket, state)}

  defp default_user_presence_payload(user), do: %{typing: false, first_name: user.first_name, email: user.email, user_id: user.id}

  defp random_color do
    hex_code =
      ColorStream.hex()
      |> Enum.take(1)
      |> List.first()
    "##{hex_code}"
  end

  def username_colors(chat), do: Enum.map(chat.messages, fn message -> message.user end) |> Enum.map(fn user -> user.email end) |> Enum.uniq() |> Enum.into(%{}, fn email -> {email, random_color()} end)
end