defmodule Probase.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false
  alias Probase.Repo

  alias Probase.Logs.User_logs
  alias Probase.Accounts.User

  def get_all_complete_user_log(search_params, page, size) do
    User_logs
    |> join(:left, [a], b in User, on: a.user_id == b.id)
    |> handleul_report_filter(search_params)
    |> order_by(desc: :inserted_at)
    |> composeul_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  # CSV Report
  def get_all_complete_user_log(_source, search_params) do
    User_logs
    |> join(:left, [a], b in User, on: a.user_id == b.id)
    |> handleul_report_filter(search_params)
    |> order_by(desc: :inserted_at)
    |> composeul_report_select()
  end

  defp handleul_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handleul_date_filter(search_params)
  end

  defp handleul_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    composeul_isearch_filter(query, search_term)
  end

  defp handleul_date_filter(query, %{"start_date" => start_date, "end_date" => end_date})
       when start_date == "" or is_nil(start_date) or end_date == "" or is_nil(end_date),
       do: query

  defp handleul_date_filter(query, %{"start_date" => start_date, "end_date" => end_date}) do
    query
    |> where(
      [a],
      fragment("CAST(? AS DATE) >= ?", a.inserted_at, ^start_date) and
        fragment("CAST(? AS DATE) <= ?", a.inserted_at, ^end_date)
    )
  end

  def query_data_final(search_params, page, size) do
    User_logs
    |> composeul_query(search_params)
    |> Repo.paginate(page: page, page_size: size)
    |> (fn %{entries: entries} = result ->
          formated =
            Enum.map(
              entries,
              &Map.merge(&1, %{
                local_total_credit: local_total_credit(entries),
                local_total_debt: local_total_debt(entries)
              })
            )

          Map.put(result, :entries, formated)
        end).()
  end

  defp local_total_credit(data),
    do:
      Enum.filter(data, &(!is_nil(&1.lyc_cr_bal)))
      |> Enum.map(&(&1.lyc_cr_bal |> Decimal.to_float()))
      |> Enum.sum()

  defp local_total_debt(data),
    do:
      Enum.filter(data, &(!is_nil(&1.lyc_dr_bal)))
      |> Enum.map(&(&1.lyc_dr_bal |> Decimal.to_float()))
      |> Enum.sum()

  def composeul_query(query, search_params) do
    User_logs

    query
    |> join(:left, [a], b in User, on: a.user_id == b.id)
    |> order_by(desc: :inserted_at)
    |> handleul_report_filter(search_params)
    |> composeul_report_select()
  end

  defp composeul_isearch_filter(query, search_term) do
    query
    |> where(
      [a, b],
      fragment(
        "lower(?) LIKE lower(?)",
        fragment("concat(?, concat(' ', ?))", b.first_name, b.last_name),
        ^search_term
      ) or
        fragment("lower(?) LIKE lower(?)", b.user_role, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.activity, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.inserted_at, ^search_term) or
        fragment("lower(?) LIKE lower(?)", "https://tracker.ops.probasegroup.com", ^search_term)
    )
  end

  defp composeul_report_select(query) do
    query
    |> select([a, b], %{
      user: fragment("concat(?, concat(' ', ?))", b.first_name, b.last_name),
      user_role: b.user_role,
      activity: a.activity,
      date: fragment("FORMAT (CAST(? AS datetime), 'dd-MMM-yyyy HH:mm')", a.inserted_at),
      host: "https://tracker.ops.probasegroup.com"
    })
  end

  @doc """
  Returns the list of tbl_user_logs.
  
  ## Examples
  
      iex> list_tbl_user_logs()
      [%UserLogs{}, ...]
  
  """
  def list_tbl_user_logs do
    Repo.all(UserLogs)
  end

  @doc """
  Gets a single user_logs.
  
  Raises `Ecto.NoResultsError` if the User logs does not exist.
  
  ## Examples
  
      iex> get_user_logs!(123)
      %UserLogs{}
  
      iex> get_user_logs!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_user_logs!(id), do: Repo.get!(User_logs, id)

  @doc """
  Creates a user_logs.
  
  ## Examples
  
      iex> create_user_logs(%{field: value})
      {:ok, %UserLogs{}}
  
      iex> create_user_logs(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_user_logs(attrs \\ %{}) do
    %User_logs{}
    |> User_logs.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_logs.
  
  ## Examples
  
      iex> update_user_logs(user_logs, %{field: new_value})
      {:ok, %UserLogs{}}
  
      iex> update_user_logs(user_logs, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_user_logs(%User_logs{} = user_logs, attrs) do
    user_logs
    |> User_logs.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_logs.
  
  ## Examples
  
      iex> delete_user_logs(user_logs)
      {:ok, %UserLogs{}}
  
      iex> delete_user_logs(user_logs)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_user_logs(%User_logs{} = user_logs) do
    Repo.delete(user_logs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_logs changes.
  
  ## Examples
  
      iex> change_user_logs(user_logs)
      %Ecto.Changeset{source: %UserLogs{}}
  
  """
  def change_user_logs(%User_logs{} = user_logs) do
    UserLogs.changeset(user_logs, %{})
  end

  # ========================== User Logs ============================

  def get_user_logs_by(user_id) do
    Repo.all(
      from u in UserLogs,
        preload: [:user],
        where: u.user_id == ^user_id,
        select:
          map(u, [
            :id,
            :user_id,
            :inserted_at,
            :activity,
            user: [:first_name, :last_name, :email]
          ])
    )
  end

  def get_all_activity_logs do
    Repo.all(
      from u in UserLogs,
        preload: [:user],
        select:
          map(u, [
            :id,
            :user_id,
            :inserted_at,
            :activity,
            user: [:first_name, :last_name, :email]
          ])
    )
  end

  alias Probase.Logs.Api_logs

  @doc """
  Returns the list of tbl_api_logs.
  
  ## Examples
  
      iex> list_tbl_api_logs()
      [%Api_logs{}, ...]
  
  """
  def list_tbl_api_logs do
    Repo.all(Api_logs)
  end

  @doc """
  Gets a single api_logs.
  
  Raises `Ecto.NoResultsError` if the Api logs does not exist.
  
  ## Examples
  
      iex> get_api_logs!(123)
      %Api_logs{}
  
      iex> get_api_logs!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_api_logs!(id), do: Repo.get!(Api_logs, id)

  @doc """
  Creates a api_logs.
  
  ## Examples
  
      iex> create_api_logs(%{field: value})
      {:ok, %Api_logs{}}
  
      iex> create_api_logs(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_api_logs(attrs \\ %{}) do
    %Api_logs{}
    |> Api_logs.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a api_logs.
  
  ## Examples
  
      iex> update_api_logs(api_logs, %{field: new_value})
      {:ok, %Api_logs{}}
  
      iex> update_api_logs(api_logs, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_api_logs(%Api_logs{} = api_logs, attrs) do
    api_logs
    |> Api_logs.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a api_logs.
  
  ## Examples
  
      iex> delete_api_logs(api_logs)
      {:ok, %Api_logs{}}
  
      iex> delete_api_logs(api_logs)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_api_logs(%Api_logs{} = api_logs) do
    Repo.delete(api_logs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking api_logs changes.
  
  ## Examples
  
      iex> change_api_logs(api_logs)
      %Ecto.Changeset{data: %Api_logs{}}
  
  """
  def change_api_logs(%Api_logs{} = api_logs, attrs \\ %{}) do
    Api_logs.changeset(api_logs, attrs)
  end
end
