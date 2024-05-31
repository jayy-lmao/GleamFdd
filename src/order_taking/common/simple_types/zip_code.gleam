import gleam/result
import order_taking/common/constrained_type

/// A zip code
pub type ZipCode {
  ZipCode(String)
}

/// Create a ZipCode from a string
/// Return Error if input is null, empty, or doesn't have 5 digits
pub fn create(str, field_name) -> Result(ZipCode, String) {
  // anything separated by an "@"
  let pattern = "\\d{5}"
  str
  |> constrained_type.create_like_string(pattern, field_name)
  |> result.map(ZipCode)
}
