import gleam/result
import gleam/io
import gleeunit
import gleeunit/should
import order_taking/common/constrained_type.{create_like, create_string}

pub fn main() {
  gleeunit.main()
}

pub fn empty_string_error_test() {
  let res = create_string(1, "")
  res
  |> result.is_error
  |> should.equal(True)
}

pub fn over_max_len_string_error_test() {
  let res = create_string(1, "Foo")
  res
  |> result.is_error
  |> should.equal(True)
}

pub fn good_string_test() {
  let res = create_string(3, "Foo")
  res
  |> result.is_error
  |> should.equal(False)
  res
  |> should.equal(Ok("Foo"))
}

pub fn fail_create_like_test() {
  let res = create_like("\\d{3}", "bbb", "must be a three digit number")
  res
  |> result.is_error
  |> should.equal(True)
  res
  |> should.equal(Error("must be a three digit number"))
}

pub fn good_create_like_test() {
  let res = create_like("\\d{3}", "123", "error")
  res
  |> result.is_error
  |> should.equal(False)
  res
  |> should.equal(Ok("123"))
}
