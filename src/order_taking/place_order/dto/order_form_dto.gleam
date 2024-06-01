import gleam/list
import order_taking/common/public_types
import order_taking/place_order/dto/address_dto.{type AddressDto}
import order_taking/place_order/dto/customer_info_dto.{type CustomerInfoDto}
import order_taking/place_order/dto/order_line_dto.{type OrderFormLineDto}

pub type OrderFormDto {
  OrderFormDto(
    order_id: String,
    customer_info: CustomerInfoDto,
    shipping_address: AddressDto,
    billing_address: AddressDto,
    lines: List(OrderFormLineDto),
  )
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
