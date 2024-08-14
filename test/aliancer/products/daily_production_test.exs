defmodule Aliancer.Products.DailyProductionTest do
  use Aliancer.DataCase

  alias Aliancer.Products.DailyProduction

  describe "daily_production" do
    alias Aliancer.Products.DailyProduction.DailyProduction

    import Aliancer.Products.DailyProductionFixtures

    @invalid_attrs %{date: nil, quantity: nil}

    test "list_daily_production/0 returns all daily_production" do
      daily_production = daily_production_fixture()
      assert DailyProduction.list_daily_production() == [daily_production]
    end

    test "get_daily_production!/1 returns the daily_production with given id" do
      daily_production = daily_production_fixture()
      assert DailyProduction.get_daily_production!(daily_production.id) == daily_production
    end

    test "create_daily_production/1 with valid data creates a daily_production" do
      valid_attrs = %{date: ~U[2024-08-13 00:56:00Z], quantity: "120.5"}

      assert {:ok, %DailyProduction{} = daily_production} = DailyProduction.create_daily_production(valid_attrs)
      assert daily_production.date == ~U[2024-08-13 00:56:00Z]
      assert daily_production.quantity == Decimal.new("120.5")
    end

    test "create_daily_production/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DailyProduction.create_daily_production(@invalid_attrs)
    end

    test "update_daily_production/2 with valid data updates the daily_production" do
      daily_production = daily_production_fixture()
      update_attrs = %{date: ~U[2024-08-14 00:56:00Z], quantity: "456.7"}

      assert {:ok, %DailyProduction{} = daily_production} = DailyProduction.update_daily_production(daily_production, update_attrs)
      assert daily_production.date == ~U[2024-08-14 00:56:00Z]
      assert daily_production.quantity == Decimal.new("456.7")
    end

    test "update_daily_production/2 with invalid data returns error changeset" do
      daily_production = daily_production_fixture()
      assert {:error, %Ecto.Changeset{}} = DailyProduction.update_daily_production(daily_production, @invalid_attrs)
      assert daily_production == DailyProduction.get_daily_production!(daily_production.id)
    end

    test "delete_daily_production/1 deletes the daily_production" do
      daily_production = daily_production_fixture()
      assert {:ok, %DailyProduction{}} = DailyProduction.delete_daily_production(daily_production)
      assert_raise Ecto.NoResultsError, fn -> DailyProduction.get_daily_production!(daily_production.id) end
    end

    test "change_daily_production/1 returns a daily_production changeset" do
      daily_production = daily_production_fixture()
      assert %Ecto.Changeset{} = DailyProduction.change_daily_production(daily_production)
    end
  end
end
