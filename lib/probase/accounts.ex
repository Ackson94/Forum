defmodule Probase.Accounts do
  @moduledoc """
  The Accounts context.
  """
  # Probase.Accounts.list_tbl_users_acc
  import Ecto.Query, warn: false
  alias Probase.Repo

  alias Probase.Accounts.User
  alias Probase.Staffs.Staff
  alias Probase.Task.Tasks
  alias Probase.Meetings.Meeting_assigned

  @doc """
  Returns the list of tbl_users.
  
  ## Examples
  
      iex> list_tbl_users()
      [%User{}, ...]
  
  """
  def list_tbl_users_acc do
    Repo.all(User)
  end

  def list_by_user_role do
    Repo.all(
      from(
        u in User,
        where: u.user_role == "dev",
        select: u
      )
    )
  end

  def lists_by_user_role do
    Repo.all(
      from(
        u in User,
        where: u.user_role == "admin",
        select: u
      )
    )
  end

  def list_by_user_role_recep do
    Repo.all(
      from(
        u in User,
        where: u.user_role == "recep",
        select: u
      )
    )
  end

  def list_by_email do
    Repo.all(
      from(
        u in User,
        where: u.email == "dev",
        select: u
      )
    )
  end

  def get_user_name(id) do
    User
    |> where([a], a.id == ^id)
    |> select([a], %{
      email: a.email,
      first_name: a.first_name,
      last_name: a.last_name
    })
    |> Repo.all()
  end

  def get_user_profile(id) do
    User
    |> where([a], a.id == ^id)
    |> Repo.one()
  end

  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user_accounts.
  
  Raises `Ecto.NoResultsError` if the User accounts does not exist.
  
  ## Examples
  
      iex> get_user_accounts!(123)
      %User{}
  
      iex> get_user_accounts!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_user_accounts!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user_accounts.
  
  ## Examples
  
      iex> create_user_accounts(%{field: value})
      {:ok, %User{}}
  
      iex> create_user_accounts(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_user_accounts(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def meeting_assigned() do
    Meeting_assigned
    |> join(:full, [tA], s in "tbl_meeting", on: tA.meeting_id == s.id)
    |> join(:full, [tA], u in "tbl_users_acc", on: tA.user_id == u.id)
    |> select([tA, s, u], %{
      first_name: u.first_name,
      last_name: u.last_name,
      meeting_title: s.meeting_title,
      project: s.project,
      start_date_time: s.start_date_time,
      agenda: s.agenda,
      id: s.id,
      chairperson: s.chairperson
    })
    |> Repo.all()
  end

  # Probase.Accounts.meeting_assigned()

  def task_assigned() do
    Tasks
    |> join(:full, [tA], s in "tbl_staff", on: tA.task_id == s.id)
    |> join(:full, [tA], u in "tbl_users_acc", on: tA.user_id == u.id)
    |> select([tA, s, u], %{
      first_name: u.first_name,
      last_name: u.last_name,
      task_name: s.task_name,
      id: s.id
    })
    |> Repo.all()
  end

  def user_maker(id) do
    User
    |> where([a], a.id == ^id)
    |> select([a], %{
      first_name: a.first_name
    })
    |> Repo.one()
  end

  @doc """
  Updates a user_accounts.
  
  
  @doc \"""
  Deletes a user_accounts.
  
  ## Examples
  
      iex> delete_user_accounts(user_accounts)
      {:ok, %User{}}
  
      iex> delete_user_accounts(user_accounts)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_user_accounts(%User{} = user_accounts) do
    Repo.delete(user_accounts)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_accounts changes.
  
  ## Examples
  
      iex> change_user_accounts(user_accounts)
      %Ecto.Changeset{source: %User{}}
  
  """
  def change_user_accounts(%User{} = user_accounts) do
    User.changeset(user_accounts, %{})
  end

  alias Probase.Accounts.Admin

  @doc """
  Returns the list of tbl_users.
  
  ## Examples
  
      iex> list_tbl_user()
      [%Admin{}, ...]
  
  """
  def list_tbl_users_acc do
    Repo.all(Admin)
  end

  def count do
    Repo.all(from u in User, select: count(u.id))
  end

  def total_users_acc do
    Repo.all(Admin) |> Enum.count()
  end

  @doc """
  Gets a single admin.
  
  Raises `Ecto.NoResultsError` if the Admin does not exist.
  
  ## Examples
  
      iex> get_admin!(123)
      %Admin{}
  
      iex> get_admin!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_admin!(id), do: Repo.get!(Admin, id)

  @doc """
  Creates a admin.
  
  ## Examples
  
      iex> create_admin(%{field: value})
      {:ok, %Admin{}}
  
      iex> create_admin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_admin(attrs \\ %{}) do
    %Admin{}
    |> Admin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a admin.
  
  ## Examples
  
      iex> update_admin(admin, %{field: new_value})
      {:ok, %Admin{}}
  
      iex> update_admin(admin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_admin(%Admin{} = admin, attrs) do
    admin
    |> Admin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a admin.
  
  ## Examples
  
      iex> delete_admin(admin)
      {:ok, %Admin{}}
  
      iex> delete_admin(admin)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_admin(%Admin{} = admin) do
    Repo.delete(admin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking admin changes.
  
  ## Examples
  
      iex> change_admin(admin)
      %Ecto.Changeset{source: %Admin{}}
  
  """
  def change_admin(%Admin{} = admin) do
    Admin.changeset(admin, %{})
  end

  alias Probase.Accounts.Employees

  @doc """
  Returns the list of tbl_employees.
  
  ## Examples
  
      iex> list_tbl_employees()
      [%Employees{}, ...]
  
  """
  def list_tbl_employees do
    Repo.all(Employees)
  end

  @doc """
  Gets a single employees.
  
  Raises `Ecto.NoResultsError` if the Employees does not exist.
  
  ## Examples
  
      iex> get_employees!(123)
      %Employees{}
  
      iex> get_employees!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_employees!(id), do: Repo.get!(Employees, id)

  @doc """
  Creates a employees.
  
  ## Examples
  
      iex> create_employees(%{field: value})
      {:ok, %Employees{}}
  
      iex> create_employees(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_employees(attrs \\ %{}) do
    %Employees{}
    |> Employees.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a employees.
  
  ## Examples
  
      iex> update_employees(employees, %{field: new_value})
      {:ok, %Employees{}}
  
      iex> update_employees(employees, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_employees(%Employees{} = employees, attrs) do
    employees
    |> Employees.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a employees.
  
  ## Examples
  
      iex> delete_employees(employees)
      {:ok, %Employees{}}
  
      iex> delete_employees(employees)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_employees(%Employees{} = employees) do
    Repo.delete(employees)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employees changes.
  
  ## Examples
  
      iex> change_employees(employees)
      %Ecto.Changeset{source: %Employees{}}
  
  """
  def change_employees(%Employees{} = employees) do
    Employees.changeset(employees, %{})
  end

  alias Probase.Accounts.Recep

  @doc """
  Returns the list of tbl_users.
  
  ## Examples
  
      iex> list_tbl_users()
      [%Recep{}, ...]
  
  """
  def list_recep_tbl_users_acc do
    Repo.all(Recep)
  end

  @doc """
  Gets a single recep.
  
  Raises `Ecto.NoResultsError` if the Recep does not exist.
  
  ## Examples
  
      iex> get_recep!(123)
      %Recep{}
  
      iex> get_recep!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_recep!(id), do: Repo.get!(Recep, id)

  @doc """
  Creates a recep.
  
  ## Examples
  
      iex> create_recep(%{field: value})
      {:ok, %Recep{}}
  
      iex> create_recep(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """

  def create_recep(attrs \\ %{}) do
    %Recep{}
    |> Recep.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a recep.
  
  ## Examples
  
      iex> delete_recep(recep)
      {:ok, %Recep{}}
  
      iex> delete_recep(recep)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_recep(%Recep{} = recep) do
    Repo.delete(recep)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recep changes.
  
  ## Examples
  
      iex> change_recep(recep)
      %Ecto.Changeset{source: %Recep{}}
  
  """
  def change_recep(%Recep{} = recep) do
    Recep.changeset(recep, %{})
  end

  ####################### TOTAL USERS SIGNED UP##############
  alias Probase.Accounts.Client

  @doc """
  Returns the list of tbl_clients.
  
  ## Examples
  
      iex> list_tbl_clients()
      [%Client{}, ...]
  
  """
  def list_tbl_clients do
    Repo.all(Client)
  end

  @doc """
  Gets a single client.
  
  Raises `Ecto.NoResultsError` if the Client does not exist.
  
  ## Examples
  
      iex> get_client!(123)
      %Client{}
  
      iex> get_client!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_client!(id), do: Repo.get!(Client, id)

  @doc """
  Creates a client.
  
  ## Examples
  
      iex> create_client(%{field: value})
      {:ok, %Client{}}
  
      iex> create_client(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_client(attrs \\ %{}) do
    %Client{}
    |> Client.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client.
  
  ## Examples
  a client.
  
  ## Examples
  
      iex> delete_client(client)
      {:ok, %Client{}}
  
      iex> delete_client(client)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_client(%Client{} = client) do
    Repo.delete(client)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client changes.
  
  ## Examples
  
      iex> change_client(client)
      %Ecto.Changeset{source: %Client{}}
  
  """
  def change_client(%Client{} = client) do
    Client.changeset(client, %{})
  end

  def list_by_company(name) do
    Repo.all(
      from(
        u in Client,
        where: u.company_name == ^name,
        select: u
      )
    )
  end

  alias Probase.Accounts.Sector

  @doc """
  Returns the list of sectors.
  
  ## Examples
  
      iex> list_sectors()
      [%Sector{}, ...]
  
  """
  def list_sectors do
    Repo.all(Sector)
  end

  @doc """
  Gets a single sector.
  
  Raises `Ecto.NoResultsError` if the Sector does not exist.
  
  ## Examples
  
      iex> get_sector!(123)
      %Sector{}
  
      iex> get_sector!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_sector!(id), do: Repo.get!(Sector, id)

  @doc """
  Creates a sector.
  
  ## Examples
  
      iex> create_sector(%{field: value})
      {:ok, %Sector{}}
  
      iex> create_sector(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_sector(attrs \\ %{}) do
    %Sector{}
    |> Sector.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a sector.
  
  ## Examples
  
      iex> delete_sector(sector)
      {:ok, %Sector{}}
  
      iex> delete_sector(sector)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_sector(%Sector{} = sector) do
    Repo.delete(sector)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sector changes.
  
  ## Examples
  
      iex> change_sector(sector)
      %Ecto.Changeset{source: %Sector{}}
  
  """
  def change_sector(%Sector{} = sector) do
    Sector.changeset(sector, %{})
  end
end
