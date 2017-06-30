module Page.Chapters.Edit exposing (..)

import Html exposing (..)
import Model exposing (Model)
import Routes exposing (Route(Chapters))
import Message exposing (Msg)
import View.FormButtons as FormButtons
import View.Q as Q


view : Model -> Html Msg
view model =
    div []
        [ br [] []
        , FormButtons.backButton model Chapters
        , h3 [] [ text <| (toString model.chapterForm.chapter_num) ++ ". " ++ model.chapterForm.name ]
        , Q.listQuestions model
        ]
