import gleam/int
import gleam/option
import gleam/result
import order_taking/common/decimal
import order_taking/common/simple_types/kilogram_quantity.{type KilogramQuantity}
import order_taking/common/simple_types/product_code.{type ProductCode}
import order_taking/common/simple_types/unit_quantity.{type UnitQuantity}

/// A Quantity is either a Unit or a Kilogram
pub type OrderQuantity {
  Unit(UnitQuantity)
  Kilogram(KilogramQuantity)
}

/// Return the value inside an OrderQuantity
pub fn value(qty) {
  case qty {
    Unit(qty) -> unit_quantity.value(qty) |> decimal.from_int
    Kilogram(qty) -> kilogram_quantity.value(qty)
  }
}

pub fn create(
  code: ProductCode,
  quantity: String,
  field_name: String,
) -> Result(OrderQuantity, String) {
  case code {
    product_code.Gizmo(_) ->
      int.parse(quantity)
      |> result.map_error(fn(_) { "Invalid int" })
      |> result.then(fn(i) { unit_quantity.create(i, field_name) })
      |> result.map(Unit)
    product_code.Widget(_) ->
      decimal.parse(quantity)
      |> option.to_result("Invalid widget quanitity")
      |> result.then(fn(i) { kilogram_quantity.create(i, field_name) })
      |> result.map(Kilogram)
  }
}
