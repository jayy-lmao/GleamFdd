import gleam/result
import gleeunit
import gleeunit/should
import order_taking/common/constrained_type.{create_like_string, create_string}

pub fn main() {
  gleeunit.main()
}

pub fn empty_string_error_test() {
  let res = "" |> create_string(1, "test")
  res
  |> result.is_error
  |> should.equal(True)
}

pub fn over_max_len_string_error_test() {
  let res = "Foo" |> create_string(1, "test")
  res
  |> result.is_error
  |> should.equal(True)
}

pub fn good_string_test() {
  let res = "Foo" |> create_string(3, "test")
  res
  |> result.is_error
  |> should.equal(False)
  res
  |> should.equal(Ok("Foo"))
}

pub fn fail_create_like_string_test() {
  let res = "bbb" |> create_like_string("\\d{3}", "like string")
  res
  |> result.is_error
  |> should.equal(True)
  res
  |> should.equal(Error("like string must match the pattern \\d{3}"))
}

pub fn good_create_like_string_test() {
  let res = "123" |> create_like_string("\\d{3}", "error")
  res
  |> result.is_error
  |> should.equal(False)
  res
  |> should.equal(Ok("123"))
}
