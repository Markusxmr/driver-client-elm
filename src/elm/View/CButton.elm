module View.CButton exposing (..)

import Html exposing (..)
import Model exposing (Model)
import Message exposing (Msg(NewUrl, Mdl))
import Routes exposing (Route)
import Material.Button as Button
import Material.Icon as Icon
import Material.Options as Options exposing (when)


view : Model -> Int -> Route -> String -> Html Msg
view model index route txt =
    Button.render Mdl
        [ 3, 2, index ]
        model.mdl
        [ Button.minifab
        , Button.raised
        , Button.colored
        , Button.ripple
        , Button.type_ "button"
        , Options.onClick (NewUrl <| route)
        ]
        [ -- Icon.i "edit"
          text txt
        ]


viewNaked : Model -> Int -> Route -> String -> Html Msg
viewNaked model index route txt =
    Button.render Mdl
        [ 3, 2, index ]
        model.mdl
        [ Button.minifab
        , Button.colored
        , Button.ripple
        , Button.type_ "button"
        , Options.onClick (NewUrl <| route)
        ]
        [ -- Icon.i "edit"
          text txt
        ]


viewIcon : Model -> Int -> Route -> String -> Html Msg
viewIcon model index route icon =
    Button.render Mdl
        [ 3, 2, index ]
        model.mdl
        [ Button.minifab
        , Button.colored
        , Button.ripple
        , Button.type_ "button"
        , Options.onClick (NewUrl <| route)
        ]
        [ Icon.i icon

        --  text txt
        ]


actionViewIcon : Model -> Int -> Msg -> String -> Html Msg
actionViewIcon model index msg icon =
    Button.render Mdl
        [ 3, 2, index ]
        model.mdl
        [ Button.minifab
        , Button.colored
        , Button.ripple
        , Button.type_ "button"
        , Options.onClick msg
        ]
        [ Icon.i icon

        --  text txt
        ]


logout : Model -> Int -> Msg -> String -> Html Msg
logout model index msg txt =
    Button.render Mdl
        [ 3, 2, index ]
        model.mdl
        [ Button.minifab
        , Button.colored
        , Button.ripple
        , Button.type_ "button"
        , Options.onClick msg
        ]
        [ text txt
        ]
