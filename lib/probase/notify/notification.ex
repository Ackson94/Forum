defmodule Probase.Notify.Notification do
  use Ecto.Schema
  import Ecto.Changeset
  alias Probase.Notify.Messager

  @timestamps_opts [local_rate: {Probase.Chats.Chat.Localtime, :local_rate, []}]
  @derive {Jason.Encoder, only: [:messages, :name, :id]}

  schema "tbl_chat_notify" do
    # has_many :messages, Messager
    field :name, :string
    field :first_name, :string
    field :user_id, :integer
    field :status, :string, default: "PENDING"

    has_many :messages, Probase.Notify.Messager, foreign_key: :chat_id, on_delete: :nilify_all
    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :first_name, :user_id])
    |> validate_required([:name])
    |> unique_constraint(:name, message: "announcementt already exists")
  end

  defmodule Localtime do
    def local_rate, do: Timex.local() |> DateTime.truncate(:second) |> DateTime.to_naive()
  end
end
