import gleam/result
import order_taking/common/constrained_type

/// The codes for Widgets start with a "W" and then four digits
pub type WidgetCode {
  WidgetCode(String)
}

/// Create an WidgetCode from a string
/// Return Error if input is null. empty, or not matching pattern
pub fn create(str, field_name) -> Result(WidgetCode, String) {
  // anything separated by an "@"
  let pattern = "W\\d{4}"
  str
  |> constrained_type.create_like_string(pattern, field_name)
  |> result.map(WidgetCode)
}
