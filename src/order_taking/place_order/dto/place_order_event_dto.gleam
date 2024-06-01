import gleam/json
import order_taking/common/public_types
import order_taking/place_order/dto/billable_order_placed_dto
import order_taking/place_order/dto/order_acknowledgment_dto
import order_taking/place_order/dto/order_placed_dto

pub type PlacedOrdeEventDto {
  OrderPlaced(order_placed_dto.OrderPlacedDto)
  BillableOrderPlaced(billable_order_placed_dto.BillableOrderPlacedDto)

  AcknowledgementSent(order_acknowledgment_dto.OrderAcknowledgmentSentDto)
}

/// For serialising
pub fn to_json(dto: PlacedOrdeEventDto) {
  let key = case dto {
    OrderPlaced(_) -> "OrderPlaced"
    BillableOrderPlaced(_) -> "BillableOrderPlaced"
    AcknowledgementSent(_) -> "AcknowledgementSent"
  }

  let obj = case dto {
    OrderPlaced(obj) -> order_placed_dto.to_json(obj)
    BillableOrderPlaced(obj) -> billable_order_placed_dto.to_json(obj)
    AcknowledgementSent(obj) -> order_acknowledgment_dto.to_json(obj)
  }

  json.object([#(key, obj)])
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
