import gleam/option.{type Option}
import order_taking/common/simple_types/email_address.{type EmailAddress}
import order_taking/common/simple_types/string50.{type String50}
import order_taking/common/simple_types/zip_code.{type ZipCode}

// ==================================
// Common compound types used throughout the OrderTaking domain
//
// Includes: customers, addresses, etc.
// Plus common errors.
//
// ==================================

// ==================================
// Customer-related types
// ==================================

pub type PersonalName {
  PersonalName(first_name: String50, last_name: String50)
}

pub type CustomerInfo {
  CustomerInfo(name: PersonalName, email_address: EmailAddress)
}

// ==================================
// Address-related
// ==================================

pub type Address {
  Address(
    address_line_1: String50,
    address_line_2: Option(String50),
    address_line_3: Option(String50),
    address_line_4: Option(String50),
    city: String50,
    zip_code: ZipCode,
  )
}
