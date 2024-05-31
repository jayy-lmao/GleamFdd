import gleam/option
import gleam/result
import order_taking/common/constrained_type

/// Constrained to be 50 chars or less, not null
pub type String50 {
  String50(String)
}

/// Return the value inside a String50
pub fn value(str50: String50) -> String {
  let String50(str) = str50
  str
}

/// Create an String50 from a string
/// Return Error if input is null, empty, or length > 50
pub fn create(str, field_name) -> Result(String50, String) {
  str
  |> constrained_type.create_string(50, field_name)
  |> result.map(String50)
}

/// Create an String50 from a string
/// Return None if input is null, empty.
/// Return error if length > maxLen
/// Return Some if the input is valid
pub fn create_option(str, field_name) -> Result(option.Option(String50), String) {
  str
  |> constrained_type.create_string_option(50, field_name)
  |> result.map(fn(optional_string) {
    optional_string
    |> option.map(String50)
  })
}
