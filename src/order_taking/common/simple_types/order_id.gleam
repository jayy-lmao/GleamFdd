import gleam/result
import order_taking/common/constrained_type

/// An Id for Orders. Constrained to be a non-empty string < 10 chars
pub type OrderId {
  OrderId(String)
}

/// Create an OrderId from a string
/// Return Error if input is null, empty, or length > 50
pub fn create(str) -> Result(OrderId, String) {
  str
  |> constrained_type.create_string(50)
  |> result.map(OrderId)
}
