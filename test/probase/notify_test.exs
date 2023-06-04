defmodule Probase.NotifyTest do
  use Probase.DataCase

  alias Probase.Notify

  describe "tbl_chat_notify" do
    alias Probase.Notify.Notification

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def notification_fixture(attrs \\ %{}) do
      {:ok, notification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notify.create_notification()

      notification
    end

    test "list_tbl_chat_notify/0 returns all tbl_chat_notify" do
      notification = notification_fixture()
      assert Notify.list_tbl_chat_notify() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert Notify.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification" do
      assert {:ok, %Notification{} = notification} = Notify.create_notification(@valid_attrs)
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notify.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{} = notification} = Notify.update_notification(notification, @update_attrs)
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()
      assert {:error, %Ecto.Changeset{}} = Notify.update_notification(notification, @invalid_attrs)
      assert notification == Notify.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = Notify.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Notify.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset" do
      notification = notification_fixture()
      assert %Ecto.Changeset{} = Notify.change_notification(notification)
    end
  end

  describe "tbl_chat_messager" do
    alias Probase.Notify.Notification

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def notification_fixture(attrs \\ %{}) do
      {:ok, notification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notify.create_notification()

      notification
    end

    test "list_tbl_chat_messager/0 returns all tbl_chat_messager" do
      notification = notification_fixture()
      assert Notify.list_tbl_chat_messager() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert Notify.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification" do
      assert {:ok, %Notification{} = notification} = Notify.create_notification(@valid_attrs)
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notify.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{} = notification} = Notify.update_notification(notification, @update_attrs)
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()
      assert {:error, %Ecto.Changeset{}} = Notify.update_notification(notification, @invalid_attrs)
      assert notification == Notify.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = Notify.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Notify.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset" do
      notification = notification_fixture()
      assert %Ecto.Changeset{} = Notify.change_notification(notification)
    end
  end

  describe "tbl_messager_alert" do
    alias Probase.Notify.Messager

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def messager_fixture(attrs \\ %{}) do
      {:ok, messager} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notify.create_messager()

      messager
    end

    test "list_tbl_messager_alert/0 returns all tbl_messager_alert" do
      messager = messager_fixture()
      assert Notify.list_tbl_messager_alert() == [messager]
    end

    test "get_messager!/1 returns the messager with given id" do
      messager = messager_fixture()
      assert Notify.get_messager!(messager.id) == messager
    end

    test "create_messager/1 with valid data creates a messager" do
      assert {:ok, %Messager{} = messager} = Notify.create_messager(@valid_attrs)
    end

    test "create_messager/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notify.create_messager(@invalid_attrs)
    end

    test "update_messager/2 with valid data updates the messager" do
      messager = messager_fixture()
      assert {:ok, %Messager{} = messager} = Notify.update_messager(messager, @update_attrs)
    end

    test "update_messager/2 with invalid data returns error changeset" do
      messager = messager_fixture()
      assert {:error, %Ecto.Changeset{}} = Notify.update_messager(messager, @invalid_attrs)
      assert messager == Notify.get_messager!(messager.id)
    end

    test "delete_messager/1 deletes the messager" do
      messager = messager_fixture()
      assert {:ok, %Messager{}} = Notify.delete_messager(messager)
      assert_raise Ecto.NoResultsError, fn -> Notify.get_messager!(messager.id) end
    end

    test "change_messager/1 returns a messager changeset" do
      messager = messager_fixture()
      assert %Ecto.Changeset{} = Notify.change_messager(messager)
    end
  end
end
