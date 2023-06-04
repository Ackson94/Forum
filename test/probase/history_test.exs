defmodule Probase.HistoryTest do
  use Probase.DataCase

  alias Probase.History

  describe "tbl_history_announce" do
    alias Probase.History.Announce

    @valid_attrs %{first_name: "some first_name", name: "some name", status: "some status"}
    @update_attrs %{first_name: "some updated first_name", name: "some updated name", status: "some updated status"}
    @invalid_attrs %{first_name: nil, name: nil, status: nil}

    def announce_fixture(attrs \\ %{}) do
      {:ok, announce} =
        attrs
        |> Enum.into(@valid_attrs)
        |> History.create_announce()

      announce
    end

    test "list_tbl_history_announce/0 returns all tbl_history_announce" do
      announce = announce_fixture()
      assert History.list_tbl_history_announce() == [announce]
    end

    test "get_announce!/1 returns the announce with given id" do
      announce = announce_fixture()
      assert History.get_announce!(announce.id) == announce
    end

    test "create_announce/1 with valid data creates a announce" do
      assert {:ok, %Announce{} = announce} = History.create_announce(@valid_attrs)
      assert announce.first_name == "some first_name"
      assert announce.name == "some name"
      assert announce.status == "some status"
    end

    test "create_announce/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = History.create_announce(@invalid_attrs)
    end

    test "update_announce/2 with valid data updates the announce" do
      announce = announce_fixture()
      assert {:ok, %Announce{} = announce} = History.update_announce(announce, @update_attrs)
      assert announce.first_name == "some updated first_name"
      assert announce.name == "some updated name"
      assert announce.status == "some updated status"
    end

    test "update_announce/2 with invalid data returns error changeset" do
      announce = announce_fixture()
      assert {:error, %Ecto.Changeset{}} = History.update_announce(announce, @invalid_attrs)
      assert announce == History.get_announce!(announce.id)
    end

    test "delete_announce/1 deletes the announce" do
      announce = announce_fixture()
      assert {:ok, %Announce{}} = History.delete_announce(announce)
      assert_raise Ecto.NoResultsError, fn -> History.get_announce!(announce.id) end
    end

    test "change_announce/1 returns a announce changeset" do
      announce = announce_fixture()
      assert %Ecto.Changeset{} = History.change_announce(announce)
    end
  end
end
