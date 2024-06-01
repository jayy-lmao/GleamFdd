import order_taking/common/public_types

pub type PlaceOrderErrorDto {
  PlaceOrderErrorDto(code: String, message: String)
}

pub fn from_domain(
  domain_obj: public_types.PlaceOrderError,
) -> PlaceOrderErrorDto {
  case domain_obj {
    public_types.PricingErrorKind(public_types.PricingError(msg)) ->
      PlaceOrderErrorDto("PricingError", msg)
    public_types.ValidationErrorKind(public_types.ValidationError(msg)) ->
      PlaceOrderErrorDto("ValidationError", msg)
    public_types.RemoteServiceErrorKind(public_types.RemoteServiceError(
      service,
      error,
    )) ->
      PlaceOrderErrorDto(
        "RemoteServiceError",
        service.name <> " (" <> service.endpoint <> ")" <> ": " <> error,
      )
  }
}
