defmodule Probase.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset
  alias Probase.Chats.Message

  @timestamps_opts [local_rate: {Probase.Chats.Chat.Localtime, :local_rate, []}]

  @derive {Jason.Encoder, only: [:messages, :name, :id]}

  schema "chats" do
    has_many :messages, Message
    field :name, :string
    field :first_name, :string
    field :user_id, :integer
    field :date, :string
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :first_name, :user_id, :date])
    |> validate_required([:name])
    |> unique_constraint(:name, message: "forum already exists")
  end

  defmodule Localtime do
    def local_rate, do: Timex.local() |> DateTime.truncate(:second) |> DateTime.to_naive()
  end
end
