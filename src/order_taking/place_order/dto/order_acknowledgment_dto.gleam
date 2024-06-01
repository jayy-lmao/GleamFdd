import order_taking/common/public_types
import order_taking/common/simple_types/email_address
import order_taking/common/simple_types/order_id

/// Event to send to other bounded contexts
pub type OrderAcknowledgmentSentDto {
  OrderAcknowledgmentSentDto(order_id: String, email_address: String)
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
