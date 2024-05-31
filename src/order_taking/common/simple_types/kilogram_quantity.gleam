import gleam/result
import order_taking/common/constrained_type
import order_taking/common/decimal.{type Decimal}

/// Constrained to be a integer between 1 and 1000
pub type KilogramQuantity {
  KilogramQuantity(Decimal)
}

/// Return the value inside an KilogramQuantity
pub fn value(qty) -> Decimal {
  let KilogramQuantity(i) = qty
  i
}

/// Create a KilogramQuantity from a int
/// Return Error if input is not an integer between 1 and 1000
pub fn create(
  quantity: Decimal,
  field_name: String,
) -> Result(KilogramQuantity, String) {
  quantity
  |> constrained_type.create_decimal(
    decimal.from_int(1),
    decimal.from_int(1000),
    field_name,
  )
  |> result.map(KilogramQuantity)
}
