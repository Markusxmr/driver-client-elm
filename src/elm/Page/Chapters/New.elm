module Page.Chapters.New exposing (..)

import Html exposing (..)
import Html.Events exposing (onInput, onSubmit)
import Html.Attributes exposing (type_, placeholder, value, class)
import Model exposing (Model, ChapterChange(..), Submit(Create))
import Message exposing (Msg(InputChapterForm, SubmitChapter))
import View.FormButtons as FormButtons
import Routes exposing (Route(Chapters))


view : Model -> Html Msg
view model =
    div []
        [ br [] []
        , Html.form [ onSubmit (SubmitChapter Create) ]
            [ h3 [] [ text "Naziv poglavlja" ]
            , div []
                [ text "Unesi broj poglavlja: "
                , br [] []
                , input
                    [ type_ "number"
                    , placeholder "Broj poglavlja"
                    , value <| toString model.chapterForm.chapter_num
                    , onInput (InputChapterForm ChapterNum)
                    ]
                    []
                ]
            , br [] []
            , div []
                [ text "Unesi naziv poglavlja: "
                , br [] []
                , input
                    [ type_ "text"
                    , placeholder "Naziv poglavlja"
                    , value model.chapterForm.name
                    , onInput (InputChapterForm ChapterName)
                    ]
                    []
                ]
            , br [] []
            , FormButtons.view model Chapters
            ]
        ]
