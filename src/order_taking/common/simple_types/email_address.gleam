import gleam/result
import order_taking/common/constrained_type

/// An email address
pub type EmailAddress {
  EmailAddress(String)
}

/// Create an EmailAddress from a string
/// Return Error if input is null, empty, or doesn't have an "@" in it
pub fn create(str) -> Result(EmailAddress, String) {
  // anything separated by an "@"
  let pattern = ".+@.+"
  str
  |> constrained_type.create_like_string(pattern, "must be a valid email")
  |> result.map(EmailAddress)
}
