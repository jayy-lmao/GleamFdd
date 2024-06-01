import order_taking/common/public_types
import order_taking/place_order/dto/billable_order_placed_dto.{
  type BillableOrderPlacedDto,
}
import order_taking/place_order/dto/order_acknowledgment_dto.{
  type OrderAcknowledgmentSentDto,
}
import order_taking/place_order/dto/order_placed_dto.{type OrderPlacedDto}

pub type PlacedOrdeEventDto {
  OrderPlaced(OrderPlacedDto)
  BillableOrderPlaced(BillableOrderPlacedDto)
  AcknowledgementSent(OrderAcknowledgmentSentDto)
}

/// Convert a PlaceOrderEvent into the corresponding DTO.
/// Used when exporting from the domain to the outside world.
pub fn from_domain(
  domain_obj: public_types.PlaceOrderEvent,
) -> PlacedOrdeEventDto {
  case domain_obj {
    public_types.OrderPlacedEvent(obj) ->
      obj |> order_placed_dto.from_domain |> OrderPlaced
    public_types.BillableOrderPlacedEvent(obj) ->
      obj |> billable_order_placed_dto.from_domain |> BillableOrderPlaced
    public_types.AcknowledgmentSentEvent(obj) ->
      obj |> order_acknowledgment_dto.from_domain |> AcknowledgementSent
  }
}
