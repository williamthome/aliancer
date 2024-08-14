defmodule Aliancer.Products.DailyProduction.DailyProduction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "daily_production" do
    field :date, :utc_datetime
    field :quantity, :decimal
    field :product_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(daily_production, attrs) do
    daily_production
    |> cast(attrs, [:date, :quantity])
    |> validate_required([:date, :quantity])
  end
end
