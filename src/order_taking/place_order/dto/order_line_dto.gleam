import gleam/dynamic
import gleam/json
import order_taking/common/public_types

/// From the order form used as input
pub type OrderFormLineDto {
  OrderFormLineDto(
    order_line_id: String,
    product_code: String,
    quantity: String,
  )
}

/// For deserialising
pub fn decoder() {
  let decoder =
    dynamic.decode3(
      OrderFormLineDto,
      dynamic.field("order_line_id", of: dynamic.string),
      dynamic.field("product_code", of: dynamic.string),
      dynamic.field("quantity", of: dynamic.string),
    )

  decoder
}

/// For serialising
pub fn to_json(dto: OrderFormLineDto) {
  json.object([
    #("order_line_id", json.string(dto.order_line_id)),
    #("product_code", json.string(dto.product_code)),
    #("quantity", json.string(dto.quantity)),
  ])
}

/// Convert the OrderFormLine into a UnvalidatedOrderLine
/// This always succeeds because there is no validation.
/// Used when importing an OrderForm from the outside world into the domain.
pub fn to_unvalidated_order_line(
  dto: OrderFormLineDto,
) -> public_types.UnvalidatedOrderLine {
  public_types.UnvalidatedOrderLine(
    order_line_id: dto.order_line_id,
    product_code: dto.product_code,
    quantity: dto.quantity,
  )
}
