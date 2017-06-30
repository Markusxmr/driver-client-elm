module Page.Tests.Show exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model)
import Message exposing (Msg(NoOp, Slider, NewUrl))
import View.FormButtons as FormButtons
import View.NavigateButtons as NavigateButtons
import View.ChapterSelect as ChapterSelect
import View.AnswerList as AnswerList
import Routes exposing (Route(ShowChapter, Chapters))
import Material.Grid exposing (grid, cell, size, Device(..))
import Material.Progress as Loading
import Material.Slider as Slider


view : Model -> Html Msg
view model =
    let
        navState =
            strong []
                [ text <|
                    (toString model.questionTest.question_num)
                        ++ " / "
                        ++ (toString (List.length model.questions))
                ]

        visible =
            case model.answerInfo of
                Nothing ->
                    True

                Just True ->
                    False

                Just False ->
                    False
    in
        div []
            [ div []
                [ br [] []
                , span []
                    [ FormButtons.backButton model Chapters
                    , text " "
                    , NavigateButtons.prevButton model
                    , text " "
                    , navState
                    , text " "
                    , span [ hidden <| not visible ] [ NavigateButtons.answerButton model ]
                    , span [ hidden visible ] [ NavigateButtons.nextButton model ]
                    , text " "
                    , span [ hidden visible ] [ NavigateButtons.infoButton model ]
                    ]
                , br [] []
                , br [] []
                , progress model
                , ChapterSelect.viewShow model
                , h5 []
                    [ text <| toString model.questionTest.question_num ++ ". " ++ model.questionTest.question
                    ]
                , br [] []
                , div []
                    [ div [ hidden (isImage model.questionTest.image) ]
                        [ text "Slika"
                        , br [] []
                        , div []
                            [ img [ src model.questionTest.image, height 250 ] []
                            ]
                        ]
                    , AnswerList.viewTests model
                    , br [] []
                    ]
                ]
            ]


progress : Model -> Html m
progress model =
    let
        currentNum =
            toFloat model.questionTest.question_num

        questionsTotal =
            toFloat <| List.length model.questions

        questionsPercent =
            currentNum * ((toFloat 100) / questionsTotal)
    in
        grid
            []
            [ cell
                [ Material.Grid.offset All 4
                , Material.Grid.size All 6
                ]
                [ Loading.progress questionsPercent
                ]
            ]


progressSlider : Model -> Html Msg
progressSlider model =
    let
        questionsCount =
            List.length model.questions
    in
        grid
            []
            [ cell
                [ Material.Grid.offset All 4
                , Material.Grid.size All 4
                ]
                [ Slider.view
                    [ Slider.onChange (Slider 1)
                    , Slider.max <| toFloat questionsCount
                    , Slider.min 1
                    , Slider.step 1
                    , Slider.value <| toFloat model.questionTest.question_num
                    ]
                ]
            ]


isImage : String -> Bool
isImage imgSrc =
    if String.contains "question_images" imgSrc then
        False
    else
        True
