defmodule Aliancer.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Aliancer.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        cost: "120.5000",
        description: "some description",
        name: "some name",
        price: "120.50",
        unit: :un,
        saleable: true,
        own_production: false
      })
      |> Aliancer.Products.create_product()

    product
  end
end
