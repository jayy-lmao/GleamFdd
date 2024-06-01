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
import order_taking/common/public_types
import order_taking/common/simple_types/price
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

  checked_address
}

/// dummy implementation
pub fn get_product_price(_product_code) {
  price.from_int(1)
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
        |> list.map(fn(event) { todo })

      let response = response.Response()
      response
    }
    Error(err) ->
      // // turn domain errors into a dto
      // let dto = err |> PlaceOrderErrorDto.fromDomain
      // // and serialize to JSON
      // let json = serializeJson(dto )
      // let response =
      //     {
      //     HttpStatusCode = 401
      //     Body = json
      //     }
      // response
      todo
  }
}
// let placeOrderApi : PlaceOrderApi =
//     fun request ->
//         // following the approach in "A Complete Serialization Pipeline" in chapter 11

//         // start with a string
//         let orderFormJson = request.Body
//         let orderForm = deserializeJson<OrderFormDto>(orderFormJson)
//         // convert to domain object
//         let unvalidatedOrder = orderForm |> OrderFormDto.toUnvalidatedOrder

//         // setup the dependencies. See "Injecting Dependencies" in chapter 9
//         let workflow =
//             Implementation.placeOrder
//                 checkProductExists // dependency
//                 checkAddressExists // dependency
//                 getProductPrice    // dependency
//                 createOrderAcknowledgmentLetter  // dependency
//                 sendOrderAcknowledgment // dependency

//         // now we are in the pure domain
//         let asyncResult = workflow unvalidatedOrder

//         // now convert from the pure domain back to a HttpResponse
//         asyncResult
//         |> Async.map (workflowResultToHttpReponse)
