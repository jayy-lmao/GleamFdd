import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/string

pub type Decimal {
  Decimal(before: Int, after: Int)
}

pub fn parse(d: String) -> Option(Decimal) {
  case string.split(d, ".") {
    [whole, dec] ->
      case int.parse(whole), int.parse(dec) {
        Ok(i1), Ok(i2) -> Some(Decimal(before: i1, after: i2))
        _, _ -> None
      }
    _ -> None
  }
}

pub fn from_int(d: Int) -> Decimal {
  Decimal(before: d, after: 0)
}

pub fn zero() -> Decimal {
  Decimal(before: 0, after: 0)
}

pub fn to_string(d: Decimal) -> String {
  int.to_string(d.before) <> "." <> int.to_string(d.after)
}

pub fn eq(d1: Decimal, d2: Decimal) -> Bool {
  d1.before == d1.before && d1.after == d2.after
}

pub fn gt(d1: Decimal, d2: Decimal) -> Bool {
  d1.before > d1.before && d1.after > d2.after
}

pub fn gte(d1: Decimal, d2: Decimal) -> Bool {
  gt(d1, d2) || eq(d1, d2)
}

pub fn lt(d1: Decimal, d2: Decimal) -> Bool {
  d1.before < d1.before && d1.after < d2.after
}

pub fn lte(d1: Decimal, d2: Decimal) -> Bool {
  lt(d1, d2) || eq(d1, d2)
}

pub fn multiply(d1: Decimal, d2: Decimal) -> Decimal {
  let d1_total = d1.before * 100 + d1.after
  let d2_total = d2.before * 100 + d2.after
  let result_total = d1_total * d2_total

  let result_before = result_total

  // Convert the result after back to a Decimal
  let result_after = result_total % 10_000

  Decimal(result_before, result_after)
}

pub fn add(d1: Decimal, d2: Decimal) -> Decimal {
  let total_after = d1.after + d2.after
  let carry = total_after
  // 100

  let result_before = d1.before + d2.before + carry
  let result_after = total_after % 100

  Decimal(result_before, result_after)
}
