defmodule Probase.Notify do
  alias Probase.Repo
  alias Probase.Notify.Notification
  alias Probase.Notify.Messager
  alias Probase.History.Announce
  import Ecto.Query

  def create_chat(chat_params), do: Notification.changeset(%Notification{}, chat_params) |> Repo.insert()

  def create_message(message_params) do
     Messager.changeset(%Messager{}, message_params) |> Repo.insert!() 
     Probase.Notify.get_chat(message_params["chat_id"])
  end

  def change_message(), do: Messager.changeset(%Messager{})

  def change_message(changeset, changes), do: Messager.changeset(changeset, changes)

  def list_chats(), do: Repo.all(Notification)

  def get_chat(chat_id) do
    query = from c in Notification, where: c.id == ^chat_id, preload: [messages: :user]
    Repo.one(query)
  end

  def get_notify_forum_id(chat_id) do
    query = from u in Notification, where: u.id == ^chat_id, select: %{user_id: u.user_id}
    Repo.one(query)
  end

  def list_tbl_chat_notify(), do: Repo.all(Notification)

  def alert_messager(), do: Repo.all(from(u in Notification, where: u.status == "PENDING", select: u)) |>Enum.count

  def new_announcement(), do: Repo.all(from(u in Notification, where: u.status == "PENDING", select: u))

  def get_pending_status() do 
    amouncement = Repo.all(from m in Notification, where: m.status == "PENDING")
    case Repo.insert_all(Announce, Enum.map(amouncement, fn map -> %{name: map.name, first_name: map.first_name, status: map.status, inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second), updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second)} end)) do
      {num, nil} -> 
        Enum.map(amouncement, fn map -> Repo.delete(map) end)
      _-> {:error, "Failed to insert"} 
    end
  end
end
