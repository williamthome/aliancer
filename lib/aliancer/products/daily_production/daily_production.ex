defmodule Aliancer.Products.DailyProduction.DailyProduction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Aliancer.Products.Product

  schema "daily_production" do
    field :date, :utc_datetime
    field :quantity, :decimal
    belongs_to :product, Product

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(daily_production, attrs) do
    daily_production
    |> cast(attrs, [:date, :quantity, :product_id])
    |> validate_required([:date, :quantity, :product_id])
    |> validate_number(:quantity, greater_than: 0)
  end
end
