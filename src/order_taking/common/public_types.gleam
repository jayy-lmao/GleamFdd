import gleam/option.{type Option}
import order_taking/common/compound_types.{type Address, type CustomerInfo}
import order_taking/common/decimal.{type Decimal}
import order_taking/common/simple_types/billing_amount.{type BillingAmount}
import order_taking/common/simple_types/email_address.{type EmailAddress}
import order_taking/common/simple_types/order_id.{type OrderId}
import order_taking/common/simple_types/order_line_id.{type OrderLineId}
import order_taking/common/simple_types/order_quantity.{type OrderQuantity}
import order_taking/common/simple_types/price.{type Price}
import order_taking/common/simple_types/product_code.{type ProductCode}

// ==================================
// This file contains the definitions of PUBLIC types (exposed at the boundary of the bounded context)
// related to the PlaceOrder workflow
// ==================================

// ------------------------------------
// inputs to the workflow

pub type UnvalidatedCustomerInfo {
  UnvalidatedCustomerInfo(
    first_name: String,
    last_name: String,
    email_address: String,
  )
}

pub type UnvalidatedAddress {
  UnvalidatedAddress(
    address_line_1: String,
    address_line_2: Option(String),
    address_line_3: Option(String),
    address_line_4: Option(String),
    city: String,
    zip_code: String,
  )
}

pub type UnvalidatedOrderLine {
  UnvalidatedOrderLine(
    order_line_id: String,
    product_code: String,
    quantity: Decimal,
  )
}

pub type UnvalidatedOrder {
  UnvalidatedOrder(
    order_id: String,
    customer_info: UnvalidatedCustomerInfo,
    shipping_address: UnvalidatedAddress,
    billing_address: UnvalidatedAddress,
    lines: List(UnvalidatedOrderLine),
  )
}

// ------------------------------------
// outputs from the workflow (success case)

/// Event will be created if the Acknowledgment was successfully posted
pub type OrderAcknowledgmentSent {
  OrderAcknowledgmentSent(order_id: OrderId, email_address: EmailAddress)
}

// priced state
pub type PricedOrderLine {
  PricedOrderLine(
    order_line_id: OrderLineId,
    product_code: ProductCode,
    quantity: OrderQuantity,
    line_price: Price,
  )
}

pub type PricedOrder {
  PricedOrder(
    order_id: OrderId,
    customer_info: CustomerInfo,
    shipping_address: Address,
    billing_address: Address,
    amount_to_bill: BillingAmount,
    lines: List(PricedOrderLine),
  )
}

/// Event to send to shipping context
pub type OrderPlaced =
  PricedOrder

/// Event to send to billing context
/// Will only be created if the amount_to_bill is not zero
pub type BillableOrderPlaced {
  BillableOrderPlaced(
    order_id: OrderId,
    billing_address: Address,
    amount_to_bill: BillingAmount,
  )
}

/// The possible events resulting from the PlaceOrder workflow
/// Not all events will occur, depending on the logic of the workflow
pub type PlacedOrderEvent {
  OrderPlacedEvent(OrderPlaced)
  BillableOrderPlacedEvent(BillableOrderPlaced)
  AcknowledgmentSentEvent(OrderAcknowledgmentSent)
}

// ------------------------------------
// error outputs

/// All the things that can go wrong in this workflow
pub type ValidationError {
  ValidationError(String)
}

pub type PricingError {
  PricingError(String)
}

pub type ServiceInfo {
  ServiceInfo(name: String, endpoint: String)
}

pub type RemoteServiceError {
  RemoteServiceError(service: ServiceInfo, error: String)
}

pub type PlaceOrderError {
  ValidationErrorKind(ValidationError)
  PricingErrorKind(PricingError)
  RemoteServiceErrorKind(RemoteServiceError)
}

// ------------------------------------
// the workflow itself

pub type PlaceOrder =
  fn(UnvalidatedOrder) -> Result(List(PlacedOrderEvent), PlaceOrderError)
