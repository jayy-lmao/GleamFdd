import gleam/list
import gleam/option
import gleam/result.{try}
import order_taking/common/compound_types
import order_taking/common/decimal
import order_taking/common/public_types
import order_taking/common/simple_types/billing_amount
import order_taking/common/simple_types/email_address
import order_taking/common/simple_types/order_id
import order_taking/common/simple_types/order_line_id
import order_taking/common/simple_types/order_quantity
import order_taking/common/simple_types/price
import order_taking/common/simple_types/product_code
import order_taking/common/simple_types/string50
import order_taking/common/simple_types/zip_code

// ======================================================
// This file contains the final implementation for the PlaceOrder workflow
//
// This represents the code in chapter 10, "Working with Errors"
//
// There are two parts:
// * the first section contains the (type-only) definitions for each step
// * the second section contains the implementations for each step
//   and the implementation of the overall workflow
// ======================================================

// ======================================================
// Section 1 : Define each step in the workflow using types
// ======================================================

// ---------------------------
// Validation step
// ---------------------------

// Product validation

type CheckProductCodeExists =
  fn(product_code.ProductCode) -> Bool

// Address validation
pub type AddressValidationError {
  InvalidFormat
  AddressNotFound
}

pub type CheckedAddress {
  CheckedAddress(public_types.UnvalidatedAddress)
}

type CheckAddressExists =
  fn(public_types.UnvalidatedAddress) ->
    Result(CheckedAddress, AddressValidationError)

// ---------------------------
// Validated Order
// ---------------------------

type ValidatedOrderLine {
  ValidatedOrderLine(
    order_line_id: order_line_id.OrderLineId,
    product_code: product_code.ProductCode,
    quantity: order_quantity.OrderQuantity,
  )
}

type ValidatedOrder {
  ValidatedOrder(
    order_id: order_id.OrderId,
    customer_info: compound_types.CustomerInfo,
    shipping_address: compound_types.Address,
    billing_address: compound_types.Address,
    lines: List(ValidatedOrderLine),
  )
}

pub type ValidateOrder =
  fn(CheckProductCodeExists) ->
    fn(CheckAddressExists) ->
      fn(public_types.UnvalidatedOrder) ->
        Result(ValidatedOrder, public_types.ValidationError)

// ---------------------------
// Pricing step
// ---------------------------

type GetProductPrice =
  fn(product_code.ProductCode) -> price.Price

// priced state is defined Domain.WorkflowTypes

pub type PriceOrder =
  fn(GetProductPrice) ->
    fn(ValidatedOrder) ->
      Result(public_types.PricedOrder, public_types.PricingError)

// price order

// ---------------------------
// Send OrderAcknowledgment
// ---------------------------

pub type HtmlString {
  HtmlString(String)
}

pub type OrderAcknowledgment {
  OrderAcknowledgment(
    email_address: email_address.EmailAddress,
    letter: HtmlString,
  )
}

type CreateOrderAcknowledgmentLetter =
  fn(public_types.PricedOrder) -> HtmlString

/// Send the order acknowledgement to the customer
/// Note that this does NOT generate an Result-type error (at least not in this workflow)
/// because on failure we will continue anyway.
/// On success, we will generate a OrderAcknowledgmentSent event,
/// but on failure we won't.
pub type SendResult {
  Sent
  NotSent
}

type SendOrderAcknowledgment =
  fn(OrderAcknowledgment) -> SendResult

pub type AcknowledgeOrder =
  fn(CreateOrderAcknowledgmentLetter) ->
    fn(SendOrderAcknowledgment) ->
      fn(public_types.PricedOrder) ->
        option.Option(public_types.OrderAcknowledgmentSent)

// ---------------------------
// Create events
// ---------------------------

pub type CreateEvents =
  fn(public_types.PricedOrder) ->
    fn(option.Option(public_types.OrderAcknowledgmentSent)) ->
      List(public_types.PlaceOrderEvent)

// ======================================================
// Section 2 : Implementation
// ======================================================

// ---------------------------
// ValidateOrder step
// ---------------------------

fn to_customer_info(
  unvalidated_customer_info: public_types.UnvalidatedCustomerInfo,
) {
  use first_name <- try(
    unvalidated_customer_info.first_name
    |> string50.create("FirstName")
    |> result.map_error(public_types.ValidationError),
    // convert creation error into ValidationError
  )

  use last_name <- try(
    unvalidated_customer_info.last_name
    |> string50.create("LastName")
    |> result.map_error(public_types.ValidationError),
    // convert creation error into ValidationError
  )
  use email_address <- try(
    unvalidated_customer_info.email_address
    |> email_address.create("email_address")
    |> result.map_error(public_types.ValidationError),
    // convert creation error into ValidationError
  )
  let customer_info =
    compound_types.CustomerInfo(
      name: compound_types.PersonalName(
        first_name: first_name,
        last_name: last_name,
      ),
      email_address: email_address,
    )

  Ok(customer_info)
}

fn to_address(checked_address: CheckedAddress) {
  let CheckedAddress(checked_address) = checked_address

  use address_line_1 <- try(
    checked_address.address_line_1
    |> string50.create("address_line_1")
    |> result.map_error(public_types.ValidationError),
    // convert creation error into ValidationError
  )

  use address_line_2 <- try(
    checked_address.address_line_2
    |> option.map(fn(addr) { string50.create_option(addr, "address_line_2") })
    |> option.unwrap(Ok(option.None))
    |> result.map_error(public_types.ValidationError),
    // convert creation error into ValidationError
  )
  use address_line_3 <- try(
    checked_address.address_line_3
    |> option.map(fn(addr) { string50.create_option(addr, "address_line_3") })
    |> option.unwrap(Ok(option.None))
    |> result.map_error(public_types.ValidationError),
    // convert creation error into ValidationError
  )
  use address_line_4 <- try(
    checked_address.address_line_4
    |> option.map(fn(addr) { string50.create_option(addr, "address_line_4") })
    |> option.unwrap(Ok(option.None))
    |> result.map_error(public_types.ValidationError),
    // convert creation error into ValidationError
  )

  use city <- try(
    checked_address.city
    |> string50.create("City")
    |> result.map_error(public_types.ValidationError),
    // convert creation error into ValidationError
  )

  use zip_code <- try(
    checked_address.zip_code
    |> zip_code.create("ZipCode")
    |> result.map_error(public_types.ValidationError),
    // convert creation error into ValidationError
  )
  let address =
    compound_types.Address(
      address_line_1: address_line_1,
      address_line_2: address_line_2,
      address_line_3: address_line_3,
      address_line_4: address_line_4,
      city: city,
      zip_code: zip_code,
    )
  Ok(address)
}

/// Call the checkAddressExists and convert the error to a ValidationError
fn to_checked_address(
  address,
  check_address: CheckAddressExists,
) -> Result(CheckedAddress, public_types.ValidationError) {
  address
  |> check_address
  |> result.map_error(fn(addr_error) {
    case addr_error {
      AddressNotFound -> public_types.ValidationError("Address not found")
      InvalidFormat -> public_types.ValidationError("Address has bad format")
    }
  })
}

fn to_order_id(order_id) {
  order_id
  |> order_id.create("order_id")
  |> result.map_error(public_types.ValidationError)
  // convert creation error into ValidationError
}

/// Helper function for validateOrder
fn to_order_line_id(order_id) {
  order_id
  |> order_line_id.create("order_line_id")
  |> result.map_error(public_types.ValidationError)
  // convert creation error into ValidationError
}

/// Helper function for validateOrder
fn to_product_code(
  product_code,
  check_product_code_exists: CheckProductCodeExists,
) {
  // create a product_code -> Result<product_code,...> function
  // suitable for using in a pipeline
  let check_product = fn(product_code) {
    case check_product_code_exists(product_code) {
      True -> Ok(product_code)
      False -> Error("Invalid: " <> product_code.value(product_code))
    }
  }

  // assemble the pipeline
  product_code
  |> product_code.create("product_code")
  |> result.then(check_product)
  |> result.map_error(public_types.ValidationError)
  // convert creation error into ValidationError
}

/// Helper function for validateOrder
fn to_order_quantity(quantity, product_code) {
  product_code
  |> order_quantity.create(quantity, "order_quantity")
  |> result.map_error(public_types.ValidationError)
  // convert creation error into ValidationError
}

/// Helper function for validateOrder
fn to_validated_order_line(check_product_code_exists: CheckProductCodeExists) {
  fn(unvalidated_order_line: public_types.UnvalidatedOrderLine) {
    use order_line_id <- try(
      unvalidated_order_line.order_line_id
      |> to_order_line_id,
    )
    use product_code <- try(
      unvalidated_order_line.product_code
      |> to_product_code(check_product_code_exists),
    )
    use quantity <- try(
      unvalidated_order_line.quantity
      |> to_order_quantity(product_code),
    )

    let validated_order_line =
      ValidatedOrderLine(
        order_line_id: order_line_id,
        product_code: product_code,
        quantity: quantity,
      )

    Ok(validated_order_line)
  }
}

fn validate_order(
  check_product_code_exists,
  check_address_exists,
  unvalidated_order: public_types.UnvalidatedOrder,
) {
  use order_id <- result.try(
    unvalidated_order.order_id
    |> to_order_id,
  )
  use customer_info <- result.try(
    unvalidated_order.customer_info
    |> to_customer_info,
  )
  use checked_shipping_address <- result.try(
    unvalidated_order.shipping_address
    |> to_checked_address(check_address_exists),
  )
  use shipping_address <- result.try(
    checked_shipping_address
    |> to_address,
  )
  use checked_billing_address <- result.try(
    unvalidated_order.billing_address
    |> to_checked_address(check_address_exists),
  )
  use billing_address <- result.try(
    checked_billing_address
    |> to_address,
  )
  use lines <- result.try(
    unvalidated_order.lines
    |> list.map(to_validated_order_line(check_product_code_exists))
    |> result.all,
  )
  let validated_order =
    ValidatedOrder(
      order_id: order_id,
      customer_info: customer_info,
      shipping_address: shipping_address,
      billing_address: billing_address,
      lines: lines,
    )
  Ok(validated_order)
}

// ---------------------------
// PriceOrder step
// ---------------------------

fn to_priced_order_line(get_product_price: GetProductPrice) {
  fn(validated_order_line: ValidatedOrderLine) {
    let qty = validated_order_line.quantity |> order_quantity.value
    let price = validated_order_line.product_code |> get_product_price
    use line_price <- try(
      price.multiply(price, qty)
      |> result.map_error(public_types.PricingError),
      // convert to PlaceOrderError
    )
    let priced_line =
      public_types.PricedOrderLine(
        order_line_id: validated_order_line.order_line_id,
        product_code: validated_order_line.product_code,
        quantity: validated_order_line.quantity,
        line_price: line_price,
      )

    Ok(priced_line)
  }
}

fn price_order(get_product_price, validated_order: ValidatedOrder) {
  use lines <- try(
    validated_order.lines
    |> list.map(to_priced_order_line(get_product_price))
    |> result.all,
    // convert list of Results to a single Result
  )

  use amount_to_bill <- try(
    lines
    |> list.map(fn(line) { line.line_price })
    // get each line price
    |> billing_amount.sum_prices
    // add them together as a BillingAmount
    |> result.map_error(public_types.PricingError),
    // convert to PlaceOrderError
  )
  let priced_order =
    public_types.PricedOrder(
      order_id: validated_order.order_id,
      customer_info: validated_order.customer_info,
      shipping_address: validated_order.shipping_address,
      billing_address: validated_order.billing_address,
      lines: lines,
      amount_to_bill: amount_to_bill,
    )
  Ok(priced_order)
}

// ---------------------------
// AcknowledgeOrder step
// ---------------------------

fn acknowledge_order(
  priced_order: public_types.PricedOrder,
  create_acknowledgment_letter,
  send_acknowledgment,
) {
  let letter = create_acknowledgment_letter(priced_order)
  let acknowledgment =
    OrderAcknowledgment(
      email_address: priced_order.customer_info.email_address,
      letter: letter,
    )

  // if the acknowledgement was successfully sent,
  // return the corresponding event, else return None
  case send_acknowledgment(acknowledgment) {
    Sent -> {
      let event =
        public_types.OrderAcknowledgmentSent(
          order_id: priced_order.order_id,
          email_address: priced_order.customer_info.email_address,
        )
      option.Some(event)
    }
    NotSent -> {
      option.None
    }
  }
}

// ---------------------------
// Create events
// ---------------------------

fn create_order_placed_event(placed_order: public_types.PricedOrder) {
  public_types.OrderPlacedEvent(placed_order)
}

fn create_billing_event(
  placed_order: public_types.PricedOrder,
) -> option.Option(public_types.BillableOrderPlaced) {
  let billing_amount = placed_order.amount_to_bill |> billing_amount.value

  case decimal.gt(billing_amount, decimal.from_int(0)) {
    True ->
      public_types.BillableOrderPlaced(
        order_id: placed_order.order_id,
        billing_address: placed_order.billing_address,
        amount_to_bill: placed_order.amount_to_bill,
      )
      |> option.Some
    False -> option.None
  }
}

/// helper to convert an Option into a List
fn list_of_option(opt) {
  case opt {
    option.Some(x) -> [x]
    option.None -> []
  }
}

fn create_events(
  priced_order,
  acknowledgment_event_opt,
) -> List(public_types.PlaceOrderEvent) {
  let acknowledgment_events =
    acknowledgment_event_opt
    |> option.map(public_types.AcknowledgmentSentEvent)
    |> list_of_option

  let order_placed_events =
    priced_order
    |> create_order_placed_event
    |> fn(event) { [event] }

  let billing_events =
    priced_order
    |> create_billing_event
    |> option.map(public_types.BillableOrderPlacedEvent)
    |> list_of_option

  // return all the events
  list.flatten([acknowledgment_events, order_placed_events, billing_events])
}

// ---------------------------
// overall workflow
// ---------------------------

pub fn place_order(
  check_product_exists,
  // dependency
  check_address_exists,
  // dependency
  get_product_price,
  // dependency
  create_order_acknowledgment_letter,
  // dependency
  send_order_acknowledgment,
  // dependency
) -> public_types.PlaceOrder {
  // definition of function

  fn(unvalidated_order) {
    use validated_order <- try(
      validate_order(
        check_product_exists,
        check_address_exists,
        unvalidated_order,
      )
      |> result.map_error(public_types.ValidationErrorKind),
    )
    use priced_order <- try(
      price_order(get_product_price, validated_order)
      |> result.map_error(public_types.PricingErrorKind),
    )

    let acknowledgement_option =
      priced_order
      |> acknowledge_order(
        create_order_acknowledgment_letter,
        send_order_acknowledgment,
      )
    let events = create_events(priced_order, acknowledgement_option)
    Ok(events)
  }
}
