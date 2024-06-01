import gleam/result
import order_taking/common/constrained_type

/// An Id for Orders. Constrained to be a non-empty string < 10 chars
pub type OrderId {
  OrderId(String)
}

/// Return the value inside an OrderId
pub fn value(id) -> String {
  let OrderId(str) = id
  str
}

/// Create an OrderId from a string
/// Return Error if input is null, empty, or length > 50
pub fn create(str, field_name) -> Result(OrderId, String) {
  str
  |> constrained_type.create_string(50, field_name)
  |> result.map(OrderId)
}
