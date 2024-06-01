import gleam/result
import order_taking/common/decimal
import order_taking/common/simple_types/kilogram_quantity
import order_taking/common/simple_types/product_code
import order_taking/common/simple_types/unit_quantity

/// A Quantity is either a Unit or a Kilogram
pub type OrderQuantity {
  Unit(unit_quantity.UnitQuantity)
  Kilogram(kilogram_quantity.KilogramQuantity)
}

/// Return the value inside an OrderQuantity
pub fn value(qty) {
  case qty {
    Unit(qty) -> unit_quantity.value(qty)
    Kilogram(qty) -> kilogram_quantity.value(qty)
  }
}

pub fn create(
  code: product_code.ProductCode,
  quantity: decimal.Decimal,
  field_name: String,
) -> Result(OrderQuantity, String) {
  case code {
    product_code.Gizmo(_) ->
      quantity
      |> unit_quantity.create(field_name)
      |> result.map(Unit)
    product_code.Widget(_) ->
      quantity
      |> kilogram_quantity.create(field_name)
      |> result.map(Kilogram)
  }
}
