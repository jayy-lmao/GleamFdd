import gleam/result
import order_taking/common/constrained_type
import order_taking/common/decimal

/// Constrained to be a integer between 1 and 1000
pub type UnitQuantity {
  UnitQuantity(decimal.Decimal)
}

/// Return the value inside an UnitQuantity
pub fn value(qty) -> decimal.Decimal {
  let UnitQuantity(d) = qty
  d
}

//     /// Create a UnitQuantity from a int
//     /// Return Error if input is not an integer between 1 and 1000
pub fn create(
  quantity: decimal.Decimal,
  field_name: String,
) -> Result(UnitQuantity, String) {
  quantity
  |> constrained_type.create_decimal(
    decimal.from_int(1),
    decimal.from_int(1000),
    field_name,
  )
  |> result.map(UnitQuantity)
}
