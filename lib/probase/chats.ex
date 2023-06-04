defmodule Probase.Chats do
  alias Probase.Repo
  alias Probase.Chats.Chat
  alias Probase.Chats.Message
  alias Probase.Accounts.User
  import Ecto.Query

  def create_chat(chat_params), do: Chat.changeset(%Chat{}, chat_params) |> Repo.insert()

  def create_message(message_params) do
    Message.changeset(%Message{}, message_params) |> Repo.insert!()
    Probase.Chats.get_chat(message_params["chat_id"])
  end

  def change_message(), do: Message.changeset(%Message{})

  def change_message(changeset, changes), do: Message.changeset(changeset, changes)

  def list_chats(), do: Repo.all(Chat)

  def get_chat(chat_id) do
    query = from c in Chat, where: c.id == ^chat_id, preload: [messages: :user]
    Repo.one(query)
  end

  def get_forum_id(chat_id) do
    query = from u in Chat, where: u.id == ^chat_id, select: %{user_id: u.user_id}
    Repo.one(query)
  end

  def search_query(search_term) do
    query = from(Chat, where: [name: ^search_term], select: [:id, :name, :first_name, :date])
    Repo.all(query)
  end

  def count_post(id),
    do:
      Message
      |> join(:left, [a], b in "chats", on: a.chat_id == b.id)
      |> where([a], a.chat_id == ^id)
      |> Repo.aggregate(:count, :chat_id)

  def last_post_name(chat_id),
    do:
      Enum.at(
        Enum.map(Repo.all(from m in Message, where: m.chat_id == ^chat_id), fn x ->
          %{
            chat_id: x.chat_id,
            user_id: x.user_id,
            content: x.content,
            doc_name: x.doc_name,
            doc_string: x.doc_string,
            doc_type: x.doc_type,
            document: x.document,
            id: x.id,
            inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
            updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
          }
        end),
        -1
      )
      |> list_user()

  def list_user(query) do
    case query do
      nil ->
        []

      _ ->
        result =
          from u in User, where: u.id == ^query.user_id, select: %{first_name: u.first_name}

        Repo.one(result)
        |> get_user_name()
    end
  end

  def get_user_name(name), do: name.first_name
end
