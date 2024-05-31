import gleam/result
import order_taking/common/constrained_type

/// An Id for OrderLines. Constrained to be a non-empty string < 10 chars
pub type OrderLineId {
  OrderLineId(String)
}

/// Return the value inside an OrderLineId
pub fn value(id) -> String {
  let OrderLineId(str) = id
  str
}

/// Create an OrderLineId from a string
/// Return Error if input is null, empty, or length > 50
pub fn create(str, field_name) -> Result(OrderLineId, String) {
  str
  |> constrained_type.create_string(50, field_name)
  |> result.map(OrderLineId)
}
