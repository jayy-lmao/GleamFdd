import gleam/result
import order_taking/common/constrained_type

/// Constrained to be a integer between 1 and 1000
pub type UnitQuantity {
  UnitQuantity(Int)
}

//     /// Create a UnitQuantity from a int
//     /// Return Error if input is not an integer between 1 and 1000
pub fn create(quantity: Int) -> Result(UnitQuantity, String) {
  quantity
  |> constrained_type.create_int(1, 1000)
  |> result.map(UnitQuantity)
}
