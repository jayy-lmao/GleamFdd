import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/regex
import gleam/string
import order_taking/common/decimal

// ===============================
// Reusable constructors and getters for constrained types
// ===============================

/// Create a constrained string using the constructor provided
/// Return Error if input is null, empty, or length > maxLen
pub fn create_string(str: String, max_len: Int) -> Result(String, String) {
  case string.is_empty(str), string.length(str) <= max_len {
    False, True -> Ok(str)
    True, _ -> Error(str <> " must not be null or empty")
    _, False ->
      Error(
        str <> "must not be more than " <> int.to_string(max_len) <> " chars",
      )
  }
}

/// Create a optional constrained string using the constructor provided
/// Return None if input is null, empty.
/// Return error if length > maxLen
/// Return Some if the input is valid
pub fn create_string_option(
  str: String,
  max_len: Int,
) -> Result(Option(String), String) {
  case string.is_empty(str), string.length(str) <= max_len {
    False, True -> Ok(Some(str))
    True, _ -> Ok(None)
    _, False ->
      Error(
        str <> "must not be more than " <> int.to_string(max_len) <> " chars",
      )
  }
}

/// Create a constrained integer using the constructor provided
/// Return Error if input is less than minVal or more than maxVal
pub fn create_int(i: Int, min_value: Int, max_value: Int) -> Result(Int, String) {
  case i {
    i if i < min_value ->
      Error(
        int.to_string(i)
        <> " must not be less than "
        <> int.to_string(min_value),
      )
    i if i > max_value ->
      Error(
        int.to_string(i)
        <> " must not be greater than "
        <> int.to_string(max_value),
      )
    _ -> Ok(i)
  }
}

/// Create a constrained decimal using the constructor provided
/// Return Error if input is less than minVal or more than maxVal
pub fn create_decimal(
  d: decimal.Decimal,
  min_value: decimal.Decimal,
  max_value: decimal.Decimal,
) -> Result(decimal.Decimal, String) {
  case decimal.lt(d, min_value), decimal.gt(d, max_value) {
    _, True ->
      Error(
        decimal.to_string(d)
        <> " must not be less than "
        <> decimal.to_string(min_value),
      )
    True, _ ->
      Error(
        decimal.to_string(d)
        <> " must not be greater than "
        <> decimal.to_string(max_value),
      )
    False, False -> Ok(d)
  }
}

/// Create a constrained string using the constructor provided
/// Return Error if input is null. empty, or does not match the regex pattern
pub fn create_like_string(
  str: String,
  pattern: String,
  error_message: String,
) -> Result(String, String) {
  let options = regex.Options(case_insensitive: False, multi_line: True)
  let assert Ok(re) = regex.compile(pattern, options)

  case string.is_empty(str), regex.check(re, str) {
    False, True -> Ok(str)
    True, _ -> Error(str <> " must not be null or empty")
    _, False -> Error(error_message)
  }
}
