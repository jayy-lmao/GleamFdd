import gleam/result
import order_taking/common/constrained_type

/// Constrained to be a integer between 1 and 1000
pub type UnitQuantity {
  UnitQuantity(Int)
}

/// Return the value inside an UnitQuantity
pub fn value(qty) -> Int {
  let UnitQuantity(i) = qty
  i
}

//     /// Create a UnitQuantity from a int
//     /// Return Error if input is not an integer between 1 and 1000
pub fn create(quantity: Int, field_name: String) -> Result(UnitQuantity, String) {
  quantity
  |> constrained_type.create_int(1, 1000, field_name)
  |> result.map(UnitQuantity)
}
