import gleam/json
import gleam/list
import order_taking/common/decimal
import order_taking/common/public_types
import order_taking/common/simple_types/billing_amount
import order_taking/common/simple_types/order_id
import order_taking/place_order/dto/address_dto
import order_taking/place_order/dto/customer_info_dto
import order_taking/place_order/dto/priced_order_line_dto

pub type OrderPlacedDto {
  OrderPlacedDto(
    order_id: String,
    customer_info: customer_info_dto.CustomerInfoDto,
    shipping_address: address_dto.AddressDto,
    billing_address: address_dto.AddressDto,
    amount_to_bill: decimal.Decimal,
    lines: List(priced_order_line_dto.PricedOrderLineDto),
  )
}

/// For serialising
pub fn to_json(dto: OrderPlacedDto) {
  json.object([
    #("order_id", json.string(dto.order_id)),
    #("customer_info", dto.customer_info |> customer_info_dto.to_json),
    #("billing_address", dto.billing_address |> address_dto.to_json),
    #("shipping_address", dto.billing_address |> address_dto.to_json),
    #("amount_to_bill", json.string(decimal.to_string(dto.amount_to_bill))),
    #("lines", json.array(dto.lines, of: priced_order_line_dto.to_json)),
  ])
}

/// Convert a OrderPlaced object into the corresponding DTO.
/// Used when exporting from the domain to the outside world.
pub fn from_domain(domain_obj: public_types.OrderPlaced) -> OrderPlacedDto {
  OrderPlacedDto(
    order_id: order_id.value(domain_obj.order_id),
    customer_info: customer_info_dto.from_customer_info(
      domain_obj.customer_info,
    ),
    shipping_address: domain_obj.shipping_address
      |> address_dto.from_address,
    billing_address: domain_obj.billing_address
      |> address_dto.from_address,
    amount_to_bill: domain_obj.amount_to_bill
      |> billing_amount.value,
    lines: domain_obj.lines
      |> list.map(priced_order_line_dto.from_domain),
  )
}
