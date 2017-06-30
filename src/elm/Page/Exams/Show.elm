module Page.Exams.Show exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model)
import Data.Answer exposing (ExamAnswer)
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
                    (toString model.questionExam.question_num)
                        ++ " / "
                        ++ (toString (List.length model.questions))
                ]

        isFinishedWithExam =
            if List.length model.questions == model.questionExam.question_num then
                True
            else
                False

        v =
            case model.examFinished of
                True ->
                    examOverview model.questionCorrectnes

                False ->
                    div []
                        [ h5 []
                            [ text <| toString model.questionExam.question_num ++ ". " ++ model.questionExam.question
                            ]
                        , br [] []
                        , div []
                            [ div [ hidden (isImage model.questionExam.image) ]
                                [ text "Slika"
                                , br [] []
                                , div []
                                    [ img [ src model.questionExam.image, height 250 ] []
                                    ]
                                ]
                            , AnswerList.viewExams model
                            , br [] []
                            ]
                        ]
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
                    , span [{- hidden isFinishedWithExam -}] [ NavigateButtons.answerButton model ]

                    --, text " "
                    --, span [ hidden <| not isFinishedWithExam ] [ NavigateButtons.finishedButton model ]
                    ]
                , br [] []
                , br [] []
                , progress model
                , ChapterSelect.viewShow model
                , v
                ]
            ]


examOverview : List ExamAnswer -> Html msg
examOverview answeredQuestions =
    div [] <|
        List.indexedMap examOverviewItem answeredQuestions


examOverviewItem : Int -> ExamAnswer -> Html msg
examOverviewItem index aq =
    div []
        [ div []
            [ text <| (toString (index + 1)) ++ ". " ++ aq.question.question
            , br [] []
            , strong [] [ text <| toString aq.correct ]
            , div [] <| List.map examOverviewAnswers aq.questionAnswers
            ]
        , br [] []
        ]


examOverviewAnswers : { b | answer : String, correct : a } -> Html msg
examOverviewAnswers a =
    div [] [ text a.answer, br [] [], text (toString a.correct) ]


progress : Model -> Html msg
progress model =
    let
        currentNum =
            toFloat model.questionExam.question_num

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
                    , Slider.value <| toFloat model.questionExam.question_num
                    ]
                ]
            ]


isImage : String -> Bool
isImage imgSrc =
    if String.contains "question_images" imgSrc then
        False
    else
        True
