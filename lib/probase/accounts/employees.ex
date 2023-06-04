defmodule Probase.Accounts.Employees do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_employees" do
    field :address, :string
    field :cell, :integer
    field :"d.o.b", :string
    field :date_engaged, :string
    field :email, :string
    field :emp_id, :string
    field :employment_duration, :string
    field :instituition, :string
    field :name, :string
    field :nationality, :string
    field :nrc_id, :string
    field :position, :string
    field :qualification, :string
    field :sex, :string
    field :ssn, :integer
    field :top_skill, :string
    field :department, :string
    field :last_name, :string
    field :supervisor, :string

    timestamps()
  end

  @doc false
  def changeset(employees, attrs) do
    employees
    |> cast(attrs, [
      :name,
      :"d.o.b",
      :sex,
      :nrc_id,
      :supervisor,
      :last_name,
      :ssn,
      :cell,
      :email,
      :address,
      :nationality,
      :position,
      :date_engaged,
      :employment_duration,
      :top_skill,
      :qualification,
      :instituition,
      :emp_id,
      :department
    ])
    |> validate_required([
      :name,
      :"d.o.b",
      :sex,
      :nrc_id,
      :ssn,
      :cell,
      :email,
      :address,
      :nationality,
      :position,
      :date_engaged,
      :employment_duration,
      :top_skill,
      :qualification,
      :instituition,
      :emp_id,
      :department
    ])
  end
end
