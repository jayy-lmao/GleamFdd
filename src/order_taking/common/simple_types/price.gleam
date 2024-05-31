import gleam/result
import order_taking/common/constrained_type
import order_taking/common/decimal.{type Decimal}

/// Constrained to be a decimal between 0.0 and 1000.00
pub type Price {
  Price(Decimal)
}

/// Return the value inside a Price
pub fn value(price: Price) -> Decimal {
  let Price(p) = price
  p
}

/// Create a Price from a decimal.
/// Return Error if input is not a decimal between 0.0 and 1000.00
pub fn create(dec: Decimal) -> Result(Price, String) {
  dec
  |> constrained_type.create_decimal(
    decimal.from_int(0),
    decimal.from_int(1000),
    "Price",
  )
  |> result.map_error(fn(err) {
    "Not expecting Price to be out of bounds: " <> err
  })
  |> result.map(Price)
}

pub fn from_int(i: Int) -> Result(Price, String) {
  i
  |> decimal.from_int()
  |> create()
}

pub fn zero() -> Price {
  Price(decimal.from_int(0))
}

pub fn add(a: Price, b: Price) -> Result(Price, String) {
  decimal.add(value(a), value(b))
  |> create
}

/// Multiply a Price by a decimal qty.
/// Return Error if new price is out of bounds.
pub fn multiply(price: Price, qty: Decimal) -> Result(Price, String) {
  price
  |> value
  |> decimal.multiply(qty)
  |> create
}
