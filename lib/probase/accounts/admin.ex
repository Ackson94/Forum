defmodule Probase.Accounts.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_users_acc" do
    field :auto_password, :string, default: "admin"
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
    field :status, :integer, default: 1
    # field :user_id, :string, 
    field :user_role, :string
    field :user_type, :integer

    belongs_to :user, Probase.Accounts.Admin, foreign_key: :user_id, type: :id

    timestamps()
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [
      :first_name,
      :last_name,
      :email,
      :password,
      :user_type,
      :user_role,
      :status,
      :auto_password,
      :user_id
    ])
    |> validate_required([
      :first_name,
      :last_name,
      :email,
      :password,
      :user_type,
      :user_role,
      :status,
      :auto_password,
      :user_id
    ])
    |> validate_length(:password,
      min: 4,
      max: 40,
      message: " should be atleast 4 to 40 characters"
    )
    |> validate_length(:first_name,
      min: 3,
      max: 100,
      message: "should be between 3 to 100 characters"
    )
    |> validate_length(:last_name,
      min: 3,
      max: 100,
      message: "should be between 3 to 100 characters"
    )
    |> validate_length(:email,
      min: 10,
      max: 150,
      message: "should be between 10 to 150 characters"
    )
    |> unique_constraint(:email, name: :tbl_users_email_index, message: " address already exists")
    |> put_pass_hash
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    Ecto.Changeset.put_change(changeset, :password, encrypt_password(password))
  end

  defp put_pass_hash(changeset), do: changeset

  def encrypt_password(password), do: Base.encode16(:crypto.hash(:sha512, password))
end
