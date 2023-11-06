import gleam/io
import gleam/int

pub type OrderEvents {
  OrderPlaced
}

pub type UnvalidatedOrder {
  UnvalidatedOrder(id: String)
}

pub type ValidatedOrder {
  ValidatedOrder(id: String)
}

pub type PlacedOrder {
  PlacedOrder(id: String)
}

pub type Validate =
  fn(UnvalidatedOrder) -> ValidatedOrder

pub type SendOrder =
  fn(ValidatedOrder) -> PlacedOrder

pub type ExtractEvents =
  fn(PlacedOrder) -> List(OrderEvents)

pub fn create_place_order(
  validate: Validate,
  send_order: SendOrder,
  extract_events: ExtractEvents,
) -> fn(UnvalidatedOrder) -> List(OrderEvents) {
  fn(order) {
    order
    |> validate
    |> send_order
    |> extract_events
  }
}

pub fn main() {
  io.println("Hello from fddd_library! ")
}
