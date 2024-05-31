import gleam/result
import gleeunit
import gleeunit/should
import order_taking/common/constrained_type.{create_like_string, create_string}

pub fn main() {
  gleeunit.main()
}

pub fn empty_string_error_test() {
  let res = "" |> create_string(1)
  res
  |> result.is_error
  |> should.equal(True)
}

pub fn over_max_len_string_error_test() {
  let res = "Foo" |> create_string(1)
  res
  |> result.is_error
  |> should.equal(True)
}

pub fn good_string_test() {
  let res = "Foo" |> create_string(3)
  res
  |> result.is_error
  |> should.equal(False)
  res
  |> should.equal(Ok("Foo"))
}

pub fn fail_create_like_string_test() {
  let res =
    "bbb" |> create_like_string("\\d{3}", "must be a three digit number")
  res
  |> result.is_error
  |> should.equal(True)
  res
  |> should.equal(Error("must be a three digit number"))
}

pub fn good_create_like_string_test() {
  let res = "123" |> create_like_string("\\d{3}", "error")
  res
  |> result.is_error
  |> should.equal(False)
  res
  |> should.equal(Ok("123"))
}
