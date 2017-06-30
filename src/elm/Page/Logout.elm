module Page.Logout exposing (..)

import Html exposing (..)
import Model exposing (Model)


view : Model -> Html msg
view model =
    div []
        [ h4 [] [ text "Odjava" ]
        ]
