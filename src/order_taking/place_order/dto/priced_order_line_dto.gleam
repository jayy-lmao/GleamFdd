import order_taking/common/decimal.{type Decimal}
import order_taking/common/public_types
import order_taking/common/simple_types/order_line_id
import order_taking/common/simple_types/order_quantity
import order_taking/common/simple_types/price
import order_taking/common/simple_types/product_code

/// Used in the output of the workflow
pub type PricedOrderLineDto {
  PricedOrderLineDto(
    order_line_id: String,
    product_code: String,
    quantity: Decimal,
    line_price: Decimal,
  )
}

/// Convert a PricedOrderLine object into the corresponding DTO.
/// Used when exporting from the domain to the outside world.
pub fn from_domain(
  domain_obj: public_types.PricedOrderLine,
) -> PricedOrderLineDto {
  // this is a simple 1:1 copy
  PricedOrderLineDto(
    order_line_id: domain_obj.order_line_id |> order_line_id.value,
    product_code: domain_obj.product_code |> product_code.value,
    quantity: domain_obj.quantity |> order_quantity.value,
    line_price: domain_obj.line_price |> price.value,
  )
}
