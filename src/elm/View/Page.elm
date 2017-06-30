module View.Page exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Message exposing (Msg(UserMode, LogoutUser))
import Routes exposing (Route(..))
import View.CButton as CButton
import Material.Scheme
import Material.Color as Color


frame : Model -> (Model -> Html Msg) -> Html Msg
frame model routeView =
    let
        errorMsg =
            if String.length model.error > 0 then
                h3 [] [ text model.error ]
            else
                span [] []
    in
        Material.Scheme.topWithScheme Color.BlueGrey Color.LightBlue <|
            div []
                [ navbar model
                , errorMsg
                , routeView model
                ]


navbar : Model -> Html Msg
navbar model =
    let
        isLoggedIn =
            case model.session.user of
                Nothing ->
                    span [] []

                Just user ->
                    button
                        [ type_ "button"
                        , onClick UserMode
                        ]
                        [ text <| toString model.userMode
                        ]

        sessionButtons =
            case model.session.user of
                Nothing ->
                    CButton.viewNaked model 1113 Login "Prijava"

                Just user ->
                    CButton.logout model 1114 LogoutUser "Odjava"
    in
        nav [ class "nav" ]
            [ CButton.viewNaked model 1111 Home "Početna"
            , CButton.viewNaked model 1112 Chapters "Poglavlja"
            , text " "
            , isLoggedIn
            , sessionButtons
            ]
