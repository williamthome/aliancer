defmodule Aliancer.Products.ProductionTest do
  use Aliancer.DataCase

  alias Aliancer.Products.Production

  describe "daily_production" do
    alias Aliancer.Products.Production.DailyProduction

    import Aliancer.ProductsFixtures
    import Aliancer.Products.ProductionFixtures

    @invalid_attrs %{date: nil, quantity: nil}

    test "list_daily_production/0 returns all daily_production" do
      daily_production = daily_production_fixture()
      assert Production.list_daily_production() == [daily_production]
    end

    test "get_daily_production!/1 returns the daily_production with given id" do
      daily_production = daily_production_fixture()
      assert Production.get_daily_production!(daily_production.id) == daily_production
    end

    test "create_daily_production/1 with valid data creates a daily_production" do
      product = product_fixture()

      valid_attrs = %{date: ~D[2024-08-13], quantity: "120.5", product_id: product.id}

      assert {:ok, %DailyProduction{} = daily_production} = Production.create_daily_production(valid_attrs)
      assert daily_production.date == ~D[2024-08-13]
      assert daily_production.quantity == Decimal.new("120.5")
    end

    test "create_daily_production/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Production.create_daily_production(@invalid_attrs)
    end

    test "update_daily_production/2 with valid data updates the daily_production" do
      daily_production = daily_production_fixture()
      update_attrs = %{date: ~D[2024-08-14], quantity: "456.7"}

      assert {:ok, %DailyProduction{} = daily_production} = Production.update_daily_production(daily_production, update_attrs)
      assert daily_production.date == ~D[2024-08-14]
      assert daily_production.quantity == Decimal.new("456.7")
    end

    test "update_daily_production/2 with invalid data returns error changeset" do
      daily_production = daily_production_fixture()
      assert {:error, %Ecto.Changeset{}} = Production.update_daily_production(daily_production, @invalid_attrs)
      assert daily_production == Production.get_daily_production!(daily_production.id)
    end

    test "delete_daily_production/1 deletes the daily_production" do
      daily_production = daily_production_fixture()
      assert {:ok, %DailyProduction{}} = Production.delete_daily_production(daily_production)
      assert_raise Ecto.NoResultsError, fn -> Production.get_daily_production!(daily_production.id) end
    end

    test "change_daily_production/1 returns a daily_production changeset" do
      daily_production = daily_production_fixture()
      assert %Ecto.Changeset{} = Production.change_daily_production(daily_production)
    end
  end
end
