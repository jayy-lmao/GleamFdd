// ======================================================
// This file contains the JSON API interface to the PlaceOrder workflow
//
// 1) The HttpRequest is turned into a DTO, which is then turned into a Domain object
// 2) The main workflow function is called
// 3) The output is turned into a DTO which is turned into a HttpResponse
// ======================================================

import gleam/http/request
import gleam/http/response
import gleam/json
import gleam/list
import gleam/result
import order_taking/common/simple_types/price
import order_taking/place_order/dto/order_form_dto
import order_taking/place_order/dto/place_order_error_dto
import order_taking/place_order/dto/place_order_event_dto
import order_taking/place_order/implementation

pub type JsonString =
  String

// pub type PlaceOrderApi =
//   fn(request.Request) -> response.Response

// =============================
// Implementation
// =============================

/// Very simplified version!
/// An API takes a HttpRequest as input and returns a async response
/// setup dummy dependencies
pub fn check_product_exists(_product_code) {
  True
}

/// dummy implementation
pub fn check_address_exists(unvalidated_address) {
  let checked_address = implementation.CheckedAddress(unvalidated_address)

  Ok(checked_address)
}

/// dummy implementation
pub fn get_product_price(_product_code) {
  result.unwrap(price.from_int(1), price.zero())
}

/// dummy implementation
pub fn create_order_acknowledgment_letter(_priced_order) {
  let letter_test = implementation.HtmlString("some text")
  letter_test
}

/// dummy implementation
pub fn send_order_acknowledgment(_order_acknowledgement) {
  implementation.Sent
}

// // -------------------------------
// // workflow
// // -------------------------------

/// This function converts the workflow output into a HttpResponse
pub fn workflow_result_to_http_reponse(result) -> response.Response(String) {
  case result {
    Ok(events) -> {
      // turn domain events into dtos
      let dtos =
        events
        |> list.map(place_order_event_dto.from_domain)

      // and serialize to JSON
      let json =
        dtos
        |> list.map(place_order_event_dto.to_json)
        |> fn(events) {
          json.object([
            #("events", json.array(from: events, of: fn(event) { event })),
          ])
          |> json.to_string
        }

      let response =
        response.Response(body: json, status: 200, headers: [
          #("Content-Type", "application/json"),
        ])
      response
    }
    Error(err) -> {
      // turn domain errors into a dto
      let dto = place_order_error_dto.from_domain(err)
      // and serialize to JSON
      let json = dto |> place_order_error_dto.to_json |> json.to_string
      let response = response.Response(status: 401, body: json, headers: [])
      response
    }
  }
}

pub fn place_order_api(
  request: request.Request(String),
) -> response.Response(String) {
  // following the approach in "A Complete Serialization Pipeline" in chapter 11

  // start with a string
  let order_form_json = request.body
  let order_form =
    json.decode(from: order_form_json, using: order_form_dto.decoder())

  case order_form {
    Ok(order_form) -> {
      // convert to domain object
      let unvalidated_order = order_form |> order_form_dto.to_unvalidated_order

      // setup the dependencies. See "Injecting Dependencies" in chapter 9
      let workflow =
        implementation.place_order(
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
        )

      // now we are in the pure domain
      let result = workflow(unvalidated_order)

      // now convert from the pure domain back to a HttpResponse
      result
      |> workflow_result_to_http_reponse
    }
    Error(_json_error) -> {
      let response =
        response.Response(
          status: 403,
          body: "JSON deserialisation error",
          headers: [],
        )
      response
    }
  }
}
