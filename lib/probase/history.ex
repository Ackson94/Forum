defmodule Probase.History do
  @moduledoc """
  The History context.
  """

  import Ecto.Query, warn: false
  alias Probase.Repo

  alias Probase.History.Announce

  @doc """
  Returns the list of tbl_history_announce.
  
  ## Examples
  
      iex> list_tbl_history_announce()
      [%Announce{}, ...]
  
  """
  def list_tbl_history_announce do
    Repo.all(Announce)
  end

  # Probase.History.preve_announcement
  def preve_announcement(),
    do: Repo.all(from(u in Announce, where: u.status == "PENDING", select: u))

  @doc """
  Gets a single announce.
  
  Raises `Ecto.NoResultsError` if the Announce does not exist.
  
  ## Examples
  
      iex> get_announce!(123)
      %Announce{}
  
      iex> get_announce!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_announce!(id), do: Repo.get!(Announce, id)

  @doc """
  Creates a announce.
  
  ## Examples
  
      iex> create_announce(%{field: value})
      {:ok, %Announce{}}
  
      iex> create_announce(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_announce(attrs \\ %{}) do
    %Announce{}
    |> Announce.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a announce.
  
  ## Examples
  
      iex> update_announce(announce, %{field: new_value})
      {:ok, %Announce{}}
  
      iex> update_announce(announce, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_announce(%Announce{} = announce, attrs) do
    announce
    |> Announce.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a announce.
  
  ## Examples
  
      iex> delete_announce(announce)
      {:ok, %Announce{}}
  
      iex> delete_announce(announce)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_announce(%Announce{} = announce) do
    Repo.delete(announce)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking announce changes.
  
  ## Examples
  
      iex> change_announce(announce)
      %Ecto.Changeset{data: %Announce{}}
  
  """
  def change_announce(%Announce{} = announce, attrs \\ %{}) do
    Announce.changeset(announce, attrs)
  end
end
