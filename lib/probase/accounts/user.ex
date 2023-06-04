defmodule Probase.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:first_name, :last_name, :email, :id]}


  schema "tbl_users_acc" do
    field :auto_password, :string, default: "user"
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
    field :status, :integer, default: 1
    field :user_role, :string
    field :user_type, :integer
    field :company_name, :string
    field :phone_no, :string

    belongs_to :user, Probase.Accounts.User, foreign_key: :user_id, type: :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :first_name,
      :last_name,
      :email,
      :user_role,
      :status,
      :password,
      :user_type,
      :user_id,
      :auto_password,
      :company_name,
      :phone_no
      # :company_name
    ])

    |> unique_constraint(:email, name: :tbl_users_email_index, message: " address already exists")
    |> put_pass_hash
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    Ecto.Changeset.put_change(changeset, :password, encrypt_password(password))
  end

  defp put_pass_hash(changeset), do: changeset

  def encrypt_password(password), do: Base.encode16(:crypto.hash(:sha512, password))
  

end
