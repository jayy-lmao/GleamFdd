import gleam/list
import gleam/result
import order_taking/common/constrained_type
import order_taking/common/decimal.{type Decimal}
import order_taking/common/simple_types/price.{type Price}

/// Constrained to be a decimal between 0.0 and 10000.00
pub type BillingAmount {
  BillingAmount(Decimal)
}

/// Create a BillingAmount from a decimal.
/// Return Error if input is not a decimal between 0.0 and 10000.00
pub fn create(dec: Decimal) -> Result(BillingAmount, String) {
  dec
  |> constrained_type.create_decimal(
    decimal.from_int(0),
    decimal.from_int(1000),
    "BillingAmount",
  )
  |> result.map(BillingAmount)
}

/// Sum a list of prices to make a billing amount
/// Return Error if total is out of bounds
pub fn sum_prices(prices: List(Price)) -> Result(BillingAmount, String) {
  prices
  |> list.map({ price.value })
  |> list.fold(decimal.zero(), decimal.add)
  |> create
}
