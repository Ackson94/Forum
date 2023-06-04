defmodule ProbaseWeb.UserController do
  use ProbaseWeb, :controller
  alias Probase.{Accounts, Repo, Logs.User_logs, Accounts.User, Chats.Chat, Chats.Message, Notify.Notification, Notify, Chats}
  alias ProbaseWeb.UserController, as: AC
  alias Phoenix.LiveView
  alias ProbaseWeb.UserLiveView
  alias Probase.Emails.Email 
  plug(ProbaseWeb.Plugs.RequireAuth when action in [:new, :dashboard, :show, :forums_func, :file_uploads, :list_users, :search_query])
  plug(ProbaseWeb.Plugs.SetUser when action in [:new, :dashboard, :show, :forums_func, :file_uploads, :list_users, :search_query])

  def list_users(conn, _params) do
    users =
      Accounts.list_tbl_users_acc()
      |> Enum.map(&%{&1 | id: sign_user_id(conn, &1.id)})
    page = %{first: "Users", last: "System users"}
    render(conn, "list_users.html", users: users, page: page)
  end

  def dashboard(conn, _params), do: render(conn, "index.html", list_user: Accounts.list_tbl_users_acc, chat_name: Chats.list_chats())

  def search_query(conn, %{"name" => name}), do: render(conn, "search.html", name_forum: Chats.search_query(name))

  def show(conn, %{"id" => chat_id}) do 
    LiveView.Controller.live_render(conn, UserLiveView,
      session: %{
        "chat" => Chats.get_chat(chat_id),
        "current_user" => conn.assigns.user,
        "user_name" => Chats.get_forum_id(chat_id)
      }
    )
  end

  def announce(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:announcement, Notification.changeset(%Notification{}, params))
    |> Ecto.Multi.run(:user_log, fn(_repo, %{announcement: announcement}) ->
      activity = "Forum created with user ID \"#{announcement.id}\""

        User_logs.changeset(%User_logs{}, %{
          user_id: conn.assigns.user.id,
          activity: activity
        })
        |> Repo.insert()
      end)
    |> Repo.transaction()
    |> case do
      {:ok, %{announcement: _forums, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Announcement created successfully")
        |> redirect(to: Routes.user_path(conn, :dashboard))
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, traverse_errors(failed_value.errors) |> List.first())
        |> redirect(to: Routes.user_path(conn, :dashboard))
    end
  end

  def local_rate, do: Timex.local() |> DateTime.truncate(:second) |> DateTime.to_naive()
    
  def forums_func(conn, param) do
    {:ok, date} = Probase.Cldr.DateTime.to_string(local_rate()) 
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:forums, Chat.changeset(%Chat{}, Map.merge(param, %{"date" => date})))
    |> Ecto.Multi.run(:user_log, fn(_repo, %{forums: forums}) ->
      activity = "Forum created with user ID \"#{forums.id}\""

        User_logs.changeset(%User_logs{}, %{
          user_id: conn.assigns.user.id,
          activity: activity
        })
        |> Repo.insert()
      end)
    |> Repo.transaction()
    |> case do
      {:ok, %{forums: _forums, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Forum created successfully")
        |> redirect(to: Routes.user_path(conn, :dashboard))
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, traverse_errors(failed_value.errors) |> List.first())
        |> redirect(to: Routes.user_path(conn, :dashboard))
    end
  end

  def file_uploads(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:forums, Message.changeset(%Message{}, params))
    |> Ecto.Multi.run(:user_log, fn(_repo, %{forums: forums}) ->
      activity = "File created with user ID \"#{forums.id}\""

        User_logs.changeset(%User_logs{}, %{
          user_id: conn.assigns.user.id,
          activity: activity
        })
        |> Repo.insert()
      end)
    |> Repo.transaction()
    |> case do
      {:ok, %{forums: _forums, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Forum created successfully")
        |> redirect(to: Routes.user_path(conn, :show, "#{params["chat_id"]}"))
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, traverse_errors(failed_value.errors) |> List.first())
        |> redirect(to: Routes.user_path(conn, :show, "#{params["chat_id"]}"))
    end
  end

  def profile(conn, _params), do: render(conn, "profile.html")

  def upload_profile(conn, params) do
      Ecto.Multi.new()
      |> Ecto.Multi.update(:profile, User.changeset(Accounts.get_user_profile(params["id"]), params))
      |> Ecto.Multi.run(:user_logs, fn (_,%{profile: profile}) ->
        activity = "profile edit with user ID \"#{profile.id}\""

          User_logs.changeset(%User_logs{}, %{
          user_id: conn.assigns.user.id,
          activity: activity
        })
          |> Repo.insert()
        end)
      |> Repo.transaction()
      |> case do
        {:ok, %{profile: _profile, user_logs: _user_log}} ->
          conn
          |> put_flash(:info, "Profile created successfully")
          |> redirect(to: Routes.user_path(conn, :dashboard))
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          conn
          |> put_flash(:error, traverse_errors(failed_value.errors) |> List.first())
          |> redirect(to: Routes.user_path(conn, :dashboard))
      end
    end

  
    def update(conn, %{"user" => user_params}) do
      with :error <- confirm_token(conn, user_params["id"]) do
        conn
        |> put_flash(:error, "invalid token received")
        |> redirect(to: Routes.user_path(conn, :list_users))
      else
        {:ok, user} ->
          Ecto.Multi.new()
          |> Ecto.Multi.update(:update, User.changeset(user, Map.delete(user_params, "id")))
          |> Ecto.Multi.run(:log, fn %{update: _update} ->
            activity =
              "Modified user details with Email \"#{user.email}\" and First Name \"#{
                user.first_name
              }\""
  
            User_log.changeset(%User_logs{}, %{
              user_id: conn.assigns.user.id,
              activity: activity
            })
            |> Repo.insert()
          end)
          |> Repo.transaction()
          |> case do
            {:ok, %{update: _update, log: _log}} ->
              conn
              |> put_flash(:info, "Changes applied successfully!")
              |> redirect(to: Routes.user_path(conn, :edit, id: user_params["id"]))
  
            {:error, _failed_operation, failed_value, _changes_so_far} ->
              conn
              |> put_flash(:error, AC.traverse_errors(failed_value.errors) |> List.first())
              |> redirect(to: Routes.user_path(conn, :edit, id: user_params["id"]))
          end
      end
    rescue
      _ ->
        conn
        |> put_flash(:error, "An error occurred, reason unknown")
        |> redirect(to: Routes.user_path(conn, :list_users))
    end
  
  
    def create(conn, %{"user" => user_params}) do
      pwd = random_string(6)
      user_params = Map.put(user_params, "password", pwd)
  
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:user, User.changeset(%User{user_id: conn.assigns.user.id}, user_params))
      |> Ecto.Multi.run(:user_log, fn %{user: user} ->
        activity =
          "Created new user with Email \"#{user.email}\" and First Name #{user.first_name}\""
  
        User_log.changeset(%User_logs{}, %{
          user_id: conn.assigns.user.id,
          activity: activity
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{user: user, user_log: _user_log}} ->
          Email.password(pwd, user.email)
  
          conn
          |> put_flash(
            :info,
            "#{String.capitalize(user.first_name)} created successfully and password is: #{pwd}"
          )
          |> redirect(to: Routes.user_path(conn, :list_users))
  
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          conn
          |> put_flash(:error, AC.traverse_errors(failed_value.errors) |> List.first())
          |> redirect(to: Routes.user_path(conn, :list_users))
      end
    rescue
      _ ->
        conn
        |> put_flash(:error, "An error occurred, reason unknown. try again")
        |> redirect(to: Routes.user_path(conn, :list_users))
    end
  
    def delete(conn, %{"id" => id}) do
      Ecto.Multi.new()
      |> Ecto.Multi.delete(:user, Accounts.get_user_accounts!(id))
      |> Ecto.Multi.run(:user_log, fn %{user: user} ->
        activity = "Deleted user with Email \"#{user.email}\" and First Name \"#{user.first_name}\""
        User_log.changeset(%User_logs{},  %{
          user_id: conn.assigns.user.id,
          activity: activity
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{user: user, user_log: _user_log}} ->
          conn
          |> put_flash(:info, "#{String.capitalize(user.first_name)} deleted successfully.")
          |> redirect(to: Routes.user_path(conn, :list_users))
  
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          conn
          |> put_flash(:error, AC.traverse_errors(failed_value.errors) |> List.first())
          |> redirect(to: Routes.user_path(conn, :list_users))
      end
    end
  
    def get_user_by_email(email) do
      case Repo.get_by(User, email: email) do
        nil -> {:error, "invalid email address"}
        user -> {:ok, user}
      end
    end
  
    def get_user_by(nt_username) do
      case Repo.get_by(User, nt_username: nt_username) do
        nil -> {:error, "invalid username/password"}
        user -> {:ok, user}
      end
    end
  
    defp sign_user_id(conn, id),
      do: Phoenix.Token.sign(conn, "user salt", id, signed_at: System.system_time(:second))
  
    # ------------------ Password Reset ---------------------
    def new_password(conn, _params), do: render(conn, "change_password.html", page: %{first: "Settings", last: "Change password"})
  
    def forgot_password(conn, _params) do
      conn
      |> put_layout(false)
      |> render("forgot_password.html")
    end
  
    def token(conn, %{"user" => user_params}) do
      with {:error, reason} <- get_user_by_email(user_params["email"]) do
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :forgot_password))
      else
        {:ok, user} ->
          token =
            Phoenix.Token.sign(conn, "user salt", user.id, signed_at: System.system_time(:second))
          Email.confirm_password_reset(token, user.email)
          conn
          |> put_flash(:info, "We have sent you a mail")
          |> redirect(to: Routes.session_path(conn, :new))
      end
    end
  
    defp confirm_token(conn, token) do
      case Phoenix.Token.verify(conn, "user salt", token, max_age: 86400) do
        {:ok, user_id} ->
          user = Repo.get!(User, user_id)
          {:ok, user}
  
        {:error, _} ->
          :error
      end
    end
  
    def default_password(conn, %{"token" => token}) do
      with :error <- confirm_token(conn, token) do
        conn
        |> put_flash(:error, "Invalid/Expired token")
        |> redirect(to: Routes.user_path(conn, :forgot_password))
      else
        {:ok, user} ->
          pwd = random_string(6)
  
          case Accounts.update_user(user, %{password: pwd, auto_password: "Y"}) do
            {:ok, _user} ->
              Email.password_alert(user.email, pwd)
  
              conn
              |> put_flash(:info, "Password reset successful")
              |> redirect(to: Routes.session_path(conn, :new))
  
            {:error, _reason} ->
              conn
              |> put_flash(:error, "An error occured, try again!")
              |> redirect(to: Routes.user_path(conn, :forgot_password))
          end
      end
    end
  
    def reset_pwd(conn, params, %{"id" => id}) do
      with :error <- confirm_token(conn, id) do
        conn
        |> put_flash(:error, "invalid token received")
        |> redirect(to:  Routes.session_path(conn, :new))
      else
        {:ok, user} ->
          pwd = random_string(6)
          changeset = User.changeset(user, %{password: pwd, auto_password: "Y"})
  
          Ecto.Multi.new()
          |> Ecto.Multi.update(:user, changeset)
          |> Ecto.Multi.insert(
  
            :user_log,
            User_logs.changeset(
              %User_logs{},
              %{
                user_id: conn.assigns.user.id,
                activity: """
                Reserted account password for user with mail \"#{user.email}\"
                """
              }
            )
          )
          |> Repo.transaction()
          |> case do
            {:ok, %{user: _user, user_log: _user_log}} ->
              Email.password_resset(params["email"], params["password"])
              conn |> json(%{"info" => "Password changed to: #{}"})
            {:error, _failed_operation, failed_value, _changes_so_far} ->
              conn |> json(%{"error" => AC.traverse_errors(failed_value.errors) |> List.first()})
          end
      end
    end
  
    def change_password(conn, %{"user" => user_params}) do
      case confirm_old_password(conn, user_params) do
        false ->
          conn
          |> put_flash(:error, "some fields were submitted empty!")
          |> redirect(to: Routes.user_path(conn, :new_password))
  
        result ->
          with {:error, reason} <- result do
            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.user_path(conn, :new_password))
          else
            {:ok, _} ->
              conn.assigns.user
              |> change_pwd(user_params)
              |> Repo.transaction()
              |> case do
                {:ok, %{update: _update, insert: _insert}} ->
                  conn
                  |> put_flash(
                    :info,
                    "Password changed successful,login using your new password."
                  )
                  |> redirect(to: Routes.session_path(conn, :new))
                {:error, _failed_operation, failed_value, _changes_so_far} ->
  
                  conn
                  |> put_flash(:info, traverse_errors(failed_value.errors) |> List.first())
                  |> redirect(to: Routes.session_path(conn, :new))
              end
          end
      end
    end
  
    def change_pwd(user, user_params) do
      pwd = String.trim(user_params["new_password"])
  
      Ecto.Multi.new()
      |> Ecto.Multi.update(:update, User.changeset(user, %{password: pwd, auto_pwd: "N"}))
      |> Ecto.Multi.insert(
        :insert,
        User_logs.changeset(
          %User_logs{},
          %{user_id: user.id, activity: "changed account password"}
        )
      )
    end
  
    defp confirm_old_password(
           conn,
           %{"old_password" => pwd, "new_password" => new_pwd}
         ) do
      with true <- String.trim(pwd) != "",
           true <- String.trim(new_pwd) != "" do
        Auth.confirm_password(
          conn.assigns.user,
          String.trim(pwd)
        )
      else
        false -> false
      end
    end
    # ------------------ / password reset -------------------

    def random_string(length) do
      :crypto.strong_rand_bytes(length)
      |> Base.url_encode64()
      |> binary_part(0, length)
    end

    def traverse_errors(errors) do
      for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
    end

  end
  