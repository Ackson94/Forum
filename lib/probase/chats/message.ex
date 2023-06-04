defmodule Probase.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Probase.Chats.Chat
  alias Probase.Accounts.User

  @timestamps_opts [local_rate: {Probase.Chats.Chat.Localtime, :local_rate, []}]
  @derive {Jason.Encoder, only: [:user, :user_id, :content, :chat_id]}

  schema "messages" do
    belongs_to :chat, Chat
    belongs_to :user, User
    field :content, :string
    field :doc_string, :string
    field :doc_name, :string
    field :doc_type, :string
    field :document, :map, virtual: true

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:chat_id, :content, :user_id, :document])
    |> file_upload()
    |> validate_required([:chat_id, :user_id])
  end

  defp file_upload(changeset) do
    file_path = get_field(changeset, :document)

    case file_path do
      %{content_type: type, filename: filename} ->
        change(changeset,
          doc_string: get_signiture_string(file_path),
          doc_name: filename,
          doc_type: type
        )

      _ ->
        changeset
    end
  end

  def get_signiture_string(file) do
    File.read!(file.path) |> Base.encode64()
  end

  defmodule Localtime do
    def local_rate, do: Timex.local() |> DateTime.truncate(:second) |> DateTime.to_naive()
  end
end
