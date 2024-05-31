import gleam/result
import order_taking/common/compound_types
import order_taking/common/public_types.{
  type UnvalidatedCustomerInfo, UnvalidatedCustomerInfo,
}
import order_taking/common/simple_types/email_address
import order_taking/common/simple_types/string50

//===============================================
// DTO for CustomerInfo
//===============================================

pub type CustomerInfoDto {
  CustomerInfoDto(first_name: String, last_name: String, email_address: String)
}

/// Convert the DTO into a UnvalidatedCustomerInfo object.
/// This always succeeds because there is no validation.
/// Used when importing an OrderForm from the outside world into the domain.
pub fn to_unvalidated_customer_info(
  dto: CustomerInfoDto,
) -> UnvalidatedCustomerInfo {
  // sometimes it's helpful to use an explicit type annotation
  // to avoid ambiguity between records with the same field names.
  let domain_obj =
    UnvalidatedCustomerInfo(
      // this is a simple 1:1 copy which always succeeds
      first_name: dto.first_name,
      last_name: dto.last_name,
      email_address: dto.email_address,
    )
  domain_obj
}

/// Convert the DTO into a CustomerInfo object
/// Used when importing from the outside world into the domain, eg loading from a database
pub fn to_customer_info(
  dto: CustomerInfoDto,
) -> Result(compound_types.CustomerInfo, String) {
  // get each (validated) simple type from the DTO as a success or failure
  use first <- result.try(dto.first_name |> string50.create)
  use last <- result.try(dto.last_name |> string50.create)
  use email <- result.try(dto.email_address |> email_address.create)

  // combine the components to create the domain object
  let name = compound_types.PersonalName(first_name: first, last_name: last)
  let info = compound_types.CustomerInfo(name: name, email_address: email)
  Ok(info)
}

/// Convert a CustomerInfo object into the corresponding DTO.
/// Used when exporting from the domain to the outside world.
pub fn from_customer_info(
  domain_obj: compound_types.CustomerInfo,
) -> CustomerInfoDto {
  // this is a simple 1:1 copy
  CustomerInfoDto(
    first_name: domain_obj.name.first_name |> string50.value,
    last_name: domain_obj.name.last_name |> string50.value,
    email_address: domain_obj.email_address |> email_address.value,
  )
}
