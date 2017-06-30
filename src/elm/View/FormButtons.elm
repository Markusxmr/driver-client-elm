module View.FormButtons exposing (..)

import Html exposing (..)
import Model exposing (Model)
import Message exposing (Msg(NewUrl, Mdl))
import Routes exposing (Route)
import Material.Button as Button
import Material.Options as Options exposing (when)


view : Model -> Route -> Html Msg
view model route =
    div []
        [ backButton model route
        , text " "
        , submitButton model
        ]


backButton : Model -> Route -> Html Msg
backButton model route =
    Button.render Mdl
        [ 3, 2, 13 ]
        model.mdl
        [ Button.raised
        , Button.colored
        , Button.ripple
        , Button.type_ "button"
        , Options.onClick (NewUrl <| route)
        ]
        [ text "Natrag"
        ]


submitButton : Model -> Html Msg
submitButton model =
    Button.render Mdl
        [ 3, 2, 21 ]
        model.mdl
        [ Button.raised
        , Button.colored
        , Button.ripple
        , Button.type_ "submit"
        ]
        [ text "Spremi"
        ]
