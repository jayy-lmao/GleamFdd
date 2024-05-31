import gleam/result
import gleam/string
import order_taking/common/simple_types/gizmo_code.{type GizmoCode}
import order_taking/common/simple_types/widget_code.{type WidgetCode}

/// A ProductCode is either a Widget or a Gizmo
pub type ProductCode {
  Widget(WidgetCode)
  Gizmo(GizmoCode)
}

/// Create an ProductCode from a string
/// Return Error if input is null, empty, or not matching pattern
pub fn create(code) -> Result(ProductCode, String) {
  case string.starts_with(code, "G"), string.starts_with(code, "W") {
    True, _ ->
      code
      |> gizmo_code.create
      |> result.map(Gizmo)
    _, True ->
      code
      |> widget_code.create
      |> result.map(Widget)
    _, _ -> Error(code <> "Must be a valid Gizmo code or Widget code")
  }
}
