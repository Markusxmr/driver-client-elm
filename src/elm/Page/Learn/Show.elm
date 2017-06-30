module Page.Learn.Show exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model)
import Message exposing (Msg(NewUrl))
import View.FormButtons as FormButtons
import View.NavigateButtons as NavigateButtons
import View.ChapterSelect as ChapterSelect
import View.AnswerList as AnswerList
import Routes exposing (Route(ShowChapter, Chapters))


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ br [] []
            , span []
                [ FormButtons.backButton model Chapters
                , text " "
                , NavigateButtons.prevButton model
                , text " "
                , NavigateButtons.nextButton model
                ]
            , br [] []
            , ChapterSelect.viewShow model
            , h5 []
                [ text <| toString model.questionLearn.question_num ++ ". " ++ model.questionLearn.question
                ]
            , br [] []
            , div []
                [ div [ hidden (isImage model.questionLearn.image) ]
                    [ text "Slika"
                    , br [] []
                    , div []
                        [ img [ src model.questionLearn.image, width 400 ] []
                        ]
                    ]
                , AnswerList.viewLearn model
                , br [] []
                ]
            ]
        ]


isImage : String -> Bool
isImage imgSrc =
    if String.contains "question_images" imgSrc then
        False
    else
        True
