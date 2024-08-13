defmodule Aliancer.Products.SubProductsTest do
  use Aliancer.DataCase

  alias Aliancer.Products.SubProducts

  describe "sub_products" do
    alias Aliancer.Products.SubProducts.SubProduct

    import Aliancer.Products.SubProductsFixtures

    @invalid_attrs %{quantity: nil}

    test "list_sub_products/0 returns all sub_products" do
      sub_product = sub_product_fixture()
      assert SubProducts.list_sub_products() == [sub_product]
    end

    test "get_sub_product!/1 returns the sub_product with given id" do
      sub_product = sub_product_fixture()
      assert SubProducts.get_sub_product!(sub_product.id) == sub_product
    end

    test "create_sub_product/1 with valid data creates a sub_product" do
      valid_attrs = %{quantity: "120.5"}

      assert {:ok, %SubProduct{} = sub_product} = SubProducts.create_sub_product(valid_attrs)
      assert sub_product.quantity == Decimal.new("120.5")
    end

    test "create_sub_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SubProducts.create_sub_product(@invalid_attrs)
    end

    test "update_sub_product/2 with valid data updates the sub_product" do
      sub_product = sub_product_fixture()
      update_attrs = %{quantity: "456.7"}

      assert {:ok, %SubProduct{} = sub_product} =
               SubProducts.update_sub_product(sub_product, update_attrs)

      assert sub_product.quantity == Decimal.new("456.7")
    end

    test "update_sub_product/2 with invalid data returns error changeset" do
      sub_product = sub_product_fixture()

      assert {:error, %Ecto.Changeset{}} =
               SubProducts.update_sub_product(sub_product, @invalid_attrs)

      assert sub_product == SubProducts.get_sub_product!(sub_product.id)
    end

    test "delete_sub_product/1 deletes the sub_product" do
      sub_product = sub_product_fixture()
      assert {:ok, %SubProduct{}} = SubProducts.delete_sub_product(sub_product)
      assert_raise Ecto.NoResultsError, fn -> SubProducts.get_sub_product!(sub_product.id) end
    end

    test "change_sub_product/1 returns a sub_product changeset" do
      sub_product = sub_product_fixture()
      assert %Ecto.Changeset{} = SubProducts.change_sub_product(sub_product)
    end
  end
end
