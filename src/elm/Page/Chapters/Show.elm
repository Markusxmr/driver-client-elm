module Page.Chapters.Show exposing (..)

import Html exposing (..)
import Model exposing (Model)
import Message exposing (Msg)
import View.FormButtons as FormButtons
import Routes exposing (Route(Chapters))
import View.Q as Q


view : Model -> Html Msg
view model =
    div []
        [ br [] []
        , FormButtons.backButton model Chapters
        , h3 [] [ text <| (toString model.chapterForm.chapter_num) ++ ". " ++ model.chapterForm.name ]
        , Q.listQuestions model
        ]
