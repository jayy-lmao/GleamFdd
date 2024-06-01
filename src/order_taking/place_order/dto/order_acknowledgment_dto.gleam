import gleam/json
import order_taking/common/public_types
import order_taking/common/simple_types/email_address
import order_taking/common/simple_types/order_id

/// Event to send to other bounded contexts
pub type OrderAcknowledgmentSentDto {
  OrderAcknowledgmentSentDto(order_id: String, email_address: String)
}

/// For serialising
pub fn to_json(dto: OrderAcknowledgmentSentDto) {
  json.object([
    #("order_id", json.string(dto.order_id)),
    #("email_address", json.string(dto.email_address)),
  ])
}

/// Convert a OrderAcknowledgmentSent object into the corresponding DTO.
/// Used when exporting from the domain to the outside world.
pub fn from_domain(
  domain_obj: public_types.OrderAcknowledgmentSent,
) -> OrderAcknowledgmentSentDto {
  OrderAcknowledgmentSentDto(
    order_id: domain_obj.order_id |> order_id.value,
    email_address: domain_obj.email_address |> email_address.value,
  )
}
