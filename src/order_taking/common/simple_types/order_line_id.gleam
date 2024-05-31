import gleam/result
import order_taking/common/constrained_type

/// An Id for OrderLines. Constrained to be a non-empty string < 10 chars
pub type OrderLineId {
  OrderLineId(String)
}

/// Create an OrderLineId from a string
/// Return Error if input is null, empty, or length > 50
pub fn create(str) -> Result(OrderLineId, String) {
  str
  |> constrained_type.create_string(50)
  |> result.map(OrderLineId)
}