import gleam/result
import order_taking/common/constrained_type

/// An email address
pub type EmailAddress {
  EmailAddress(String)
}

/// Return the value inside an EmailAddress
pub fn value(addr) -> String {
  let EmailAddress(str) = addr
  str
}

/// Create an EmailAddress from a string
/// Return Error if input is null, empty, or doesn't have an "@" in it
pub fn create(str, field_name) -> Result(EmailAddress, String) {
  // anything separated by an "@"
  let pattern = ".+@.+"
  str
  |> constrained_type.create_like_string(pattern, field_name)
  |> result.map(EmailAddress)
}
