import gleam/result
import order_taking/common/constrained_type

/// The codes for Gizmos start with a "G" and then three digits.
pub type GizmoCode {
  GizmoCode(String)
}

/// Create an GizmoCode from a string
/// Return Error if input is null, empty, or not matching pattern
pub fn create(str) -> Result(GizmoCode, String) {
  // anything separated by an "@"
  let pattern = "G\\d{3}"
  str
  |> constrained_type.create_like_string(pattern, "must be a valid email")
  |> result.map(GizmoCode)
}
