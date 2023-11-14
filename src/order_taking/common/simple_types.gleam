import gleam/string
import gleam/option.{None, Option, Some}
import gleam/regex
import gleam/int
import order_taking/common/decimal

// ===============================
// Simple types and constrained types related to the OrderTaking domain.
//
// E.g. Single case discriminated unions (aka wrappers), enums, etc
// ===============================

/// An email address
type EmailAddress {
  EmailAddress(String)
}

/// A zip code
type ZipCode {
  ZipCode(String)
}

/// An Id for Orders. Constrained to be a non-empty string < 10 chars
type OrderId {
  OrderId(String)
}

/// An Id for OrderLines. Constrained to be a non-empty string < 10 chars
type OrderLineId {
  OrderLineId(String)
}

/// The codes for Widgets start with a "W" and then four digits
type WidgetCode {
  WidgetCode(String)
}

/// The codes for Gizmos start with a "G" and then three digits.
type GizmoCode {
  GizmoCode(String)
}

/// A ProductCode is either a Widget or a Gizmo
type ProductCode {
  Widget(WidgetCode)
  Gizmo(GizmoCode)
}

/// Constrained to be a integer between 1 and 1000
type UnitQuantity {
  UnitQuantity(Int)
}

/// Constrained to be a decimal between 0.05 and 100.00
type KilogramQuantity {
  KilogramQuantity(Float)
}

/// A Quantity is either a Unit or a Kilogram
type OrderQuantity {
  Unit(UnitQuantity)
  Kilogram(KilogramQuantity)
}

/// Constrained to be a decimal between 0.0 and 1000.00
type Price {
  Price(Float)
}

/// Constrained to be a decimal between 0.0 and 10000.00
type BillingAmount {
  BillingAmount(Float)
}
// /// Represents a PDF attachment
// type PdfAttachment = {
//     Name : string
//     Bytes: byte[]
//     }

// // F# VERSION DIFFERENCE
// // Modules with the same name as a non-generic type will cause an error in versions of F# before v4.1 (VS2017)
// // so change the module definition to include a [<CompilationRepresentation>] attribute like this:
// (*
// [<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
// module String50 =
// *)

// module EmailAddress =

//     /// Return the string value inside an EmailAddress
//     let value (EmailAddress str) = str

//     /// Create an EmailAddress from a string
//     /// Return Error if input is null, empty, or doesn't have an "@" in it
//     let create fieldName str =
//         let pattern = ".+@.+" // anything separated by an "@"
//         ConstrainedType.createLike fieldName EmailAddress pattern str

// module ZipCode =

//     /// Return the string value inside a ZipCode
//     let value (ZipCode str) = str

//     /// Create a ZipCode from a string
//     /// Return Error if input is null, empty, or doesn't have 5 digits
//     let create fieldName str =
//         let pattern = "\d{5}"
//         ConstrainedType.createLike fieldName ZipCode pattern str

// module OrderId =

//     /// Return the string value inside an OrderId
//     let value (OrderId str) = str

//     /// Create an OrderId from a string
//     /// Return Error if input is null, empty, or length > 50
//     let create fieldName str =
//         ConstrainedType.createString fieldName OrderId 50 str

// module OrderLineId =

//     /// Return the string value inside an OrderLineId
//     let value (OrderLineId str) = str

//     /// Create an OrderLineId from a string
//     /// Return Error if input is null, empty, or length > 50
//     let create fieldName str =
//         ConstrainedType.createString fieldName OrderLineId 50 str

// module WidgetCode =

//     /// Return the string value inside a WidgetCode
//     let value (WidgetCode code) = code

//     /// Create an WidgetCode from a string
//     /// Return Error if input is null. empty, or not matching pattern
//     let create fieldName code =
//         // The codes for Widgets start with a "W" and then four digits
//         let pattern = "W\d{4}"
//         ConstrainedType.createLike fieldName WidgetCode pattern code

// module GizmoCode =

//     /// Return the string value inside a GizmoCode
//     let value (GizmoCode code) = code

//     /// Create an GizmoCode from a string
//     /// Return Error if input is null, empty, or not matching pattern
//     let create fieldName code =
//         // The codes for Gizmos start with a "G" and then three digits.
//         let pattern = "G\d{3}"
//         ConstrainedType.createLike fieldName GizmoCode pattern code

// module ProductCode =

//     /// Return the string value inside a ProductCode
//     let value productCode =
//         match productCode with
//         | Widget (WidgetCode wc) -> wc
//         | Gizmo (GizmoCode gc) -> gc

//     /// Create an ProductCode from a string
//     /// Return Error if input is null, empty, or not matching pattern
//     let create fieldName code =
//         if String.IsNullOrEmpty(code) then
//             let msg = sprintf "%s: Must not be null or empty" fieldName
//             Error msg
//         else if code.StartsWith("W") then
//             WidgetCode.create fieldName code
//             |> Result.map Widget
//         else if code.StartsWith("G") then
//             GizmoCode.create fieldName code
//             |> Result.map Gizmo
//         else
//             let msg = sprintf "%s: Format not recognized '%s'" fieldName code
//             Error msg

// module UnitQuantity  =

//     /// Return the value inside a UnitQuantity
//     let value (UnitQuantity v) = v

//     /// Create a UnitQuantity from a int
//     /// Return Error if input is not an integer between 1 and 1000
//     let create fieldName v =
//         ConstrainedType.createInt fieldName UnitQuantity 1 1000 v

// module KilogramQuantity =

//     /// Return the value inside a KilogramQuantity
//     let value (KilogramQuantity v) = v

//     /// Create a KilogramQuantity from a decimal.
//     /// Return Error if input is not a decimal between 0.05 and 100.00
//     let create fieldName v =
//         ConstrainedType.createDecimal fieldName KilogramQuantity 0.05M 100M v

// module OrderQuantity  =

//     /// Return the value inside a OrderQuantity
//     let value qty =
//         match qty with
//         | Unit uq ->
//             uq |> UnitQuantity.value |> decimal
//         | Kilogram kq ->
//             kq |> KilogramQuantity.value

//     /// Create a OrderQuantity from a productCode and quantity
//     let create fieldName productCode quantity  =
//         match productCode with
//         | Widget _ ->
//             UnitQuantity.create fieldName (int quantity) // convert float to int
//             |> Result.map OrderQuantity.Unit             // lift to OrderQuantity type
//         | Gizmo _ ->
//             KilogramQuantity.create fieldName quantity
//             |> Result.map OrderQuantity.Kilogram         // lift to OrderQuantity type

// module Price =

//     /// Return the value inside a Price
//     let value (Price v) = v

//     /// Create a Price from a decimal.
//     /// Return Error if input is not a decimal between 0.0 and 1000.00
//     let create v =
//         ConstrainedType.createDecimal "Price" Price 0.0M 1000M v

//     /// Create a Price from a decimal.
//     /// Throw an exception if out of bounds. This should only be used if you know the value is valid.
//     let unsafeCreate v =
//         create v
//         |> function
//             | Ok price ->
//                 price
//             | Error err ->
//                 failwithf "Not expecting Price to be out of bounds: %s" err

//     /// Multiply a Price by a decimal qty.
//     /// Return Error if new price is out of bounds.
//     let multiply qty (Price p) =
//         create (qty * p)

// module BillingAmount =

//     /// Return the value inside a BillingAmount
//     let value (BillingAmount v) = v

//     /// Create a BillingAmount from a decimal.
//     /// Return Error if input is not a decimal between 0.0 and 10000.00
//     let create v =
//         ConstrainedType.createDecimal "BillingAmount" BillingAmount 0.0M 10000M v

//     /// Sum a list of prices to make a billing amount
//     /// Return Error if total is out of bounds
//     let sumPrices prices =
//         let total = prices |> List.map Price.value |> List.sum
//         create total
