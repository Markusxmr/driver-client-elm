module Page.Chapters.ChapterList exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Keyed as Keyed
import Model exposing (Model, UserMode(..))
import Data.Chapter exposing (Chapter)
import Data.DeleteVariant exposing (DeleteType(ChapterDelete))
import Message exposing (Msg(NewUrl, ConfirmDelete))
import Routes exposing (Route(..))
import Material.Grid exposing (grid, cell, size, Device(..))
import View.CButton as CButton
import Helpers exposing (userModeHidden)
import Material.List as Lists
import Material.Options as Options exposing (when)
import Material.Typography as Typo


chapters : Model -> Html Msg
chapters model =
    let
        sortedChapters =
            List.sortBy .chapter_num model.chapters
    in
        grid []
            [ cell [ Material.Grid.size All 12 ]
                [ span [ hidden (userModeHidden model) ]
                    [ CButton.view model -1 NewChapter "Dodaj poglavlje"
                    ]
                ]
            , cell
                [ Material.Grid.offset Desktop 3
                , Material.Grid.size Desktop 6
                , Material.Grid.size Tablet 12
                , Material.Grid.size Phone 12
                ]
                [ h3 [] [ text "Poglavlja" ]
                , Keyed.ul [] <|
                    List.indexedMap (chapter model) sortedChapters
                ]
            ]


chapter : Model -> Int -> Chapter -> ( String, Html Msg )
chapter model index c =
    let
        userMode =
            case model.userMode of
                Show ->
                    span []
                        [ CButton.viewIcon model (index + 100) (Learn c.id 1) "info"
                        , CButton.viewIcon model (index + 100) (Tests c.id 1) "info"
                        , CButton.viewIcon model (index + 100) (Exams c.id 1) "info"
                        ]

                Admin ->
                    span []
                        [ CButton.viewIcon model (index + 100) (Learn c.id 1) "info"
                        , CButton.viewIcon model (index + 100) (Tests c.id 1) "info"
                        , CButton.viewIcon model (index + 100) (Exams c.id 1) "info"
                        , CButton.viewIcon model index (EditChapter c.id) "edit"
                        , CButton.actionViewIcon model (index + 200) (ConfirmDelete c.id ChapterDelete) "delete"
                        ]
    in
        ( toString c.id
        , Lists.li
            [ Lists.withSubtitle
            ]
            [ Lists.content
                [ Options.css "cursor" "pointer"
                , Options.onClick (NewUrl <| ShowChapter c.id)
                , Typo.left
                ]
                [ text <| toString c.chapter_num ++ "." ++ c.name
                , Lists.subtitle [] [ text "Broj pitanja" ]
                ]
            , Lists.content2 []
                [ userMode
                ]
            ]
        )
