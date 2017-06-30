module Page.Questions.Show exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model)
import Message exposing (Msg)
import View.FormButtons as FormButtons
import View.ChapterSelect as ChapterSelect
import View.AnswerList as AnswerList
import Routes exposing (Route(ShowChapter))
import Material.Grid exposing (grid, cell, size, Device(..))


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ br [] []
            , FormButtons.backButton model (ShowChapter model.questionForm.chapter_id)
            , br [] []
            , ChapterSelect.viewShow model
            , h5 []
                [ text <| toString model.questionForm.question_num ++ ". " ++ model.questionForm.question
                ]
            , br [] []
            , grid [ Material.Grid.offset Desktop 2 ]
                [ cell
                    [ Material.Grid.size Desktop 3
                    , Material.Grid.size Tablet 12
                    , Material.Grid.size Phone 12
                    ]
                    [ div []
                        [ div [ hidden (isImage model.questionForm.image) ]
                            [ text "Slika"
                            , br [] []
                            , div []
                                [ img [ src model.questionForm.image, width 400 ] []
                                ]
                            ]
                        ]
                    ]
                , cell
                    [ Material.Grid.size Desktop 7
                    , Material.Grid.size Tablet 12
                    , Material.Grid.size Phone 12
                    ]
                    [ AnswerList.viewShow model
                    ]
                ]
            , br [] []
            ]
        ]


isImage : String -> Bool
isImage imgSrc =
    if String.contains "question_images" imgSrc then
        False
    else
        True
