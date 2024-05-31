import order_taking/common/decimal.{type Decimal}
import order_taking/common/public_types

/// From the order form used as input
pub type OrderFormLineDto {
  OrderFormLineDto(
    order_line_id: String,
    product_code: String,
    quantity: Decimal,
  )
}

/// Convert the OrderFormLine into a UnvalidatedOrderLine
/// This always succeeds because there is no validation.
/// Used when importing an OrderForm from the outside world into the domain.
pub fn to_unvalidated_order_line(
  dto: OrderFormLineDto,
) -> public_types.UnvalidatedOrderLine {
  // this is a simple 1:1 copy
  public_types.UnvalidatedOrderLine(
    order_line_id: dto.order_line_id,
    product_code: dto.product_code,
    quantity: dto.quantity,
  )
}
