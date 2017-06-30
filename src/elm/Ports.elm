port module Ports exposing (..)

import Json.Encode exposing (Value)


port storeSession : Maybe String -> Cmd msg


port onSessionChange : (Value -> msg) -> Sub msg


port deleteDialog : { id : Int, dt : String } -> Cmd msg


port deleteConfirmation : ({ id : Int, dt : String } -> msg) -> Sub msg


port upload : { id : Int, element : String } -> Cmd msg


port reqListener : (String -> msg) -> Sub msg
