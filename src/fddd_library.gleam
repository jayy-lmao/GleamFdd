import gleam/bytes_builder
import gleam/dict
import gleam/erlang/atom
import gleam/erlang/process
import gleam/http/request
import gleam/http/response
import logging
import mist
import order_taking/place_order/api.{place_order_api}

@external(erlang, "logger", "update_primary_config")
fn logger_update_primary_config(
  config: dict.Dict(atom.Atom, atom.Atom),
) -> Result(Nil, any)

pub fn main() {
  logging.configure()
  let _ =
    logger_update_primary_config(
      dict.from_list([
        #(atom.create_from_string("level"), atom.create_from_string("debug")),
      ]),
    )

  let not_found =
    response.new(404)
    |> response.set_body(mist.Bytes(bytes_builder.new()))

  let assert Ok(_) =
    fn(req: request.Request(mist.Connection)) -> response.Response(
      mist.ResponseData,
    ) {
      case request.path_segments(req) {
        ["order"] -> submit_order(req)
        _ -> not_found
      }
    }
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}

fn submit_order(
  request: request.Request(mist.Connection),
) -> response.Response(mist.ResponseData) {
  place_order_api(request)
}
