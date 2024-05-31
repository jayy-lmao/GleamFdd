import gleam/result
import gleam/string
import order_taking/common/simple_types/gizmo_code.{type GizmoCode}
import order_taking/common/simple_types/widget_code.{type WidgetCode}

/// A ProductCode is either a Widget or a Gizmo
pub type ProductCode {
  Widget(WidgetCode)
  Gizmo(GizmoCode)
}

/// Return the value inside an ProductCode
pub fn value(id) -> String {
  case id {
    Widget(code) -> widget_code.value(code)
    Gizmo(code) -> gizmo_code.value(code)
  }
}

/// Create an ProductCode from a string
/// Return Error if input is null, empty, or not matching pattern
pub fn create(code, field_name) -> Result(ProductCode, String) {
  case string.starts_with(code, "G"), string.starts_with(code, "W") {
    True, _ ->
      code
      |> gizmo_code.create(field_name)
      |> result.map(Gizmo)
    _, True ->
      code
      |> widget_code.create(field_name)
      |> result.map(Widget)
    _, _ -> Error(code <> "Must be a valid Gizmo code or Widget code")
  }
}
