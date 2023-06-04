defmodule ProbaseWeb.NotifyController do
  use ProbaseWeb, :controller
  alias Phoenix.LiveView
  alias ProbaseWeb.NotifyLiveView
  alias Probase.{Repo, Logs.User_logs, Notify, Notify.Messager, History}
  alias ProbaseWeb.UserController, as: Error
  plug(ProbaseWeb.Plugs.RequireAuth when action in [:check_announce, :announ_view, :previous_ann, :notify_uploads])
  plug(ProbaseWeb.Plugs.SetUser when action in [:check_announce, :announ_view, :previous_ann, :notify_uploads])

  def check_announce(conn, _param), do: render(conn, "check_announce.html", announ: Notify.new_announcement())

  def announ_view(conn, %{"id" => chat_id}) do
      LiveView.Controller.live_render(conn, NotifyLiveView,
          session: %{
          "user_notify_chat" => Notify.get_chat(chat_id),
          "login_users" => conn.assigns.user,
          "user_name" => Notify.get_notify_forum_id(chat_id)
          }
      )
  end

  def previous_ann(conn, _params), do: render(conn, "previous_ann.html", prev: History.preve_announcement())
  
  def notify_uploads(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:notify, Messager.changeset(%Messager{}, params))
    |> Ecto.Multi.run(:user_log, fn(_repo, %{notify: notify}) ->
      activity = "File created with user ID \"#{notify.id}\""

        User_logs.changeset(%User_logs{}, %{
          user_id: conn.assigns.user.id,
          activity: activity
        })
        |> Repo.insert()
      end)
    |> Repo.transaction()
    |> case do
      {:ok, %{notify: _notify, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Upload created successfully")
        |> redirect(to: Routes.notify_path(conn, :announ_view, "#{params["chat_id"]}"))
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, Error.traverse_errors(failed_value.errors) |> List.first())
        |> redirect(to: Routes.notify_path(conn, :announ_view, "#{params["chat_id"]}"))
    end
  end
end