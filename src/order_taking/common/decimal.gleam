import gleam/string
import gleam/int
import gleam/option.{None, Option, Some}

pub type Decimal {
  Decimal(before: Int, after: Int)
}

pub fn parse(d: String) -> Option(Decimal) {
  case string.split(d, ".") {
    [whole, dec] ->
      case [int.parse(whole), int.parse(dec)] {
        [Ok(i1), Ok(i2)] -> Some(Decimal(before: i1, after: i2))
        _ -> None
      }
    _ -> None
  }
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
