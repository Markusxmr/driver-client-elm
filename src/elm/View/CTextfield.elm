module View.CTextfield exposing (..)

import Html exposing (..)
import Model exposing (Model)
import Message exposing (Msg(Mdl))
import Material.Textfield as Textfield
import Material.Options as Options


view : Model -> String -> Int -> String -> (String -> Msg) -> Html Msg
view model value index label msg =
    Textfield.render Mdl
        [ 1, index ]
        model.mdl
        [ Textfield.label label
        , Textfield.value value
        , Options.onInput msg
        ]
        []


view1 : Model -> String -> Int -> String -> (String -> Msg) -> Html Msg
view1 model value index label msg =
    Textfield.render Mdl
        [ 1, index ]
        model.mdl
        [ Textfield.label label
        , Textfield.value value
        , Options.onInput msg
        ]
        []
