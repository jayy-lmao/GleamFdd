import gleam/option.{type Option, None, Some}
import gleam/result.{try}
import order_taking/common/compound_types
import order_taking/common/public_types
import order_taking/common/simple_types/string50
import order_taking/common/simple_types/zip_code

pub type AddressDto {
  AddressDto(
    address_line_1: String,
    address_line_2: Option(String),
    address_line_3: Option(String),
    address_line_4: Option(String),
    city: String,
    zip_code: String,
  )
}

/// This always succeeds because there is no validation.
/// Used when importing an OrderForm from the outside world into the domain.
pub fn to_unvalidated_address(
  dto: AddressDto,
) -> public_types.UnvalidatedAddress {
  // this is a simple 1:1 copy
  public_types.UnvalidatedAddress(
    address_line_1: dto.address_line_1,
    address_line_2: dto.address_line_2,
    address_line_3: dto.address_line_3,
    address_line_4: dto.address_line_4,
    city: dto.city,
    zip_code: dto.zip_code,
  )
}

/// Convert the DTO into a Address object
/// Used when importing from the outside world into the domain, eg loading from a database.
pub fn to_address(dto: AddressDto) -> Result(compound_types.Address, String) {
  // get each (validated) simple type from the DTO as a success or failure
  use address_line_1 <- try(
    dto.address_line_1
    |> string50.create("address_line_1"),
  )
  use address_line_2 <- try(
    dto.address_line_2
    |> option.map(fn(addr) { string50.create_option(addr, "address_line_2") })
    |> option.unwrap(Ok(None)),
  )
  use address_line_3 <- try(
    dto.address_line_3
    |> option.map(fn(addr) { string50.create_option(addr, "address_line_3") })
    |> option.unwrap(Ok(None)),
  )
  use address_line_4 <- try(
    dto.address_line_4
    |> option.map(fn(addr) { string50.create_option(addr, "address_line_4") })
    |> option.unwrap(Ok(None)),
  )
  use city <- try(dto.city |> string50.create("city"))
  use zip_code <- try(dto.zip_code |> zip_code.create("zip_code"))

  // combine the components to create the domain object
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

/// Convert a Address object into the corresponding DTO.
/// Used when exporting from the domain to the outside world.
pub fn from_address(domain_obj: compound_types.Address) -> AddressDto {
  // this is a simple 1:1 copy
  AddressDto(
    address_line_1: domain_obj.address_line_1 |> string50.value,
    address_line_2: domain_obj.address_line_2
      |> option.map(string50.value),
    address_line_3: domain_obj.address_line_3
      |> option.map(string50.value),
    address_line_4: domain_obj.address_line_4
      |> option.map(string50.value),
    city: domain_obj.city |> string50.value,
    zip_code: domain_obj.zip_code |> zip_code.value,
  )
}
