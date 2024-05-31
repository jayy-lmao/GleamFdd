import gleam/result
import order_taking/common/constrained_type
import order_taking/common/decimal.{type Decimal}

/// Constrained to be a integer between 1 and 1000
pub type KilogramQuantity {
  KilogramQuantity(Decimal)
}

//     /// Create a KilogramQuantity from a int
//     /// Return Error if input is not an integer between 1 and 1000
pub fn create(quantity: Decimal) -> Result(KilogramQuantity, String) {
  quantity
  |> constrained_type.create_decimal(
    decimal.from_int(1),
    decimal.from_int(1000),
  )
  |> result.map(KilogramQuantity)
}
