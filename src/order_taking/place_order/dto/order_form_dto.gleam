import gleam/dynamic
import gleam/list
import order_taking/common/public_types
import order_taking/place_order/dto/address_dto
import order_taking/place_order/dto/customer_info_dto
import order_taking/place_order/dto/order_line_dto

pub type OrderFormDto {
  OrderFormDto(
    order_id: String,
    customer_info: customer_info_dto.CustomerInfoDto,
    shipping_address: address_dto.AddressDto,
    billing_address: address_dto.AddressDto,
    lines: List(order_line_dto.OrderFormLineDto),
  )
}

/// For deserialising
pub fn decoder() {
  let decoder =
    dynamic.decode5(
      OrderFormDto,
      dynamic.field("order_id", of: dynamic.string),
      dynamic.field("customer_info", of: customer_info_dto.decoder()),
      dynamic.field("shipping_address", of: address_dto.decoder()),
      dynamic.field("billing_address", of: address_dto.decoder()),
      dynamic.field("lines", of: dynamic.list(order_line_dto.decoder())),
    )

  decoder
}

/// Convert the OrderForm into a UnvalidatedOrder
/// This always succeeds because there is no validation.
pub fn to_unvalidated_order(dto: OrderFormDto) -> public_types.UnvalidatedOrder {
  public_types.UnvalidatedOrder(
    order_id: dto.order_id,
    customer_info: dto.customer_info
      |> customer_info_dto.to_unvalidated_customer_info,
    shipping_address: dto.shipping_address |> address_dto.to_unvalidated_address,
    billing_address: dto.billing_address |> address_dto.to_unvalidated_address,
    lines: dto.lines |> list.map(order_line_dto.to_unvalidated_order_line),
  )
}
