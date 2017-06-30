module Helpers exposing (..)

import Model exposing (UserMode(..))


userModeHidden : { a | userMode : UserMode } -> Bool
userModeHidden model =
    case model.userMode of
        Show ->
            True

        Admin ->
            False
