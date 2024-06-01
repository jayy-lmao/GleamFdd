import gleam/json
import order_taking/common/decimal
import order_taking/common/public_types
import order_taking/common/simple_types/billing_amount
import order_taking/common/simple_types/order_id
import order_taking/place_order/dto/address_dto

pub type BillableOrderPlacedDto {
  BillableOrderPlacedDto(
    order_id: String,
    billing_address: address_dto.AddressDto,
    amount_to_bill: decimal.Decimal,
  )
}

/// For serialising
pub fn to_json(dto: BillableOrderPlacedDto) {
  json.object([
    #("order_id", json.string(dto.order_id)),
    #("amount_to_bill", json.string(decimal.to_string(dto.amount_to_bill))),
    #(
      "address",
      dto.billing_address
        |> address_dto.to_json,
    ),
  ])
}

/// Convert a BillableOrderPlaced object into the corresponding DTO.
/// Used when exporting from the domain to the outside world.
pub fn from_domain(
  domain_obj: public_types.BillableOrderPlaced,
) -> BillableOrderPlacedDto {
  BillableOrderPlacedDto(
    order_id: order_id.value(domain_obj.order_id),
    billing_address: domain_obj.billing_address
      |> address_dto.from_address,
    amount_to_bill: domain_obj.amount_to_bill
      |> billing_amount.value,
  )
}
