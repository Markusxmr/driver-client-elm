module View.AnswerList exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Lazy exposing (lazy)
import Html.Keyed as Keyed
import Model exposing (Model, Submit(Delete))
import Data.Answer exposing (Answer, emptyAnswer)
import Message exposing (Msg(AnswerQuestion, Mdl, NewUrl, SubmitAnswer))
import Routes exposing (Route(EditAnswer))
import Material.Options as Options
import Material.Typography as Typo
import Material.Toggles as Toggles
import Material.Grid exposing (grid, cell, size, Device(..))


view : Model -> Html Msg
view model =
    div []
        [ br [] []
        , div [] [ lazy answerList model ]
        ]


answerList : Model -> Html Msg
answerList model =
    let
        sortById =
            List.sortBy .id model.answers

        filterSorted =
            List.filter (\af -> af.question_id == model.questionForm.id) sortById
    in
        Keyed.node "div"
            []
            (List.map answer filterSorted)


viewShow : Model -> Html Msg
viewShow model =
    div [] <|
        (br [] [])
            :: (model.answers
                    |> List.sortBy .id
                    |> List.filter (\af -> af.question_id == model.questionForm.id)
                    |> List.map answerShow
               )


viewLearn : Model -> Html Msg
viewLearn model =
    div [] <|
        (br [] [])
            :: (model.answers
                    |> List.sortBy .id
                    |> List.filter (\af -> af.question_id == model.questionLearn.id)
                    |> List.map answerShow
               )


viewTests : Model -> Html Msg
viewTests model =
    div [] <|
        (br [] [])
            :: (model.answers
                    |> List.sortBy .id
                    |> List.filter (\af -> af.question_id == model.questionTest.id)
                    |> List.indexedMap (\af -> answerTest model af)
               )


viewExams : Model -> Html Msg
viewExams model =
    div [] <|
        (br [] [])
            :: (model.answers
                    |> List.sortBy .id
                    |> List.filter (\af -> af.question_id == model.questionExam.id)
                    |> List.indexedMap (\af -> answerExam model af)
               )


answer : Answer -> ( String, Html Msg )
answer af =
    let
        formId =
            (toString af.id)

        correctness =
            case af.correct of
                True ->
                    span [ style [ ( "color", "green" ) ] ] [ text "Točno" ]

                False ->
                    span [ style [ ( "color", "red" ) ] ] [ text "Netočno" ]
    in
        ( toString af.id
        , div
            [ style
                [ ( "width", "350px" )
                , ( "margin", "0 auto" )
                ]
            ]
            [ span [ style [ ( "float", "left" ) ] ] [ correctness ]
            , button
                [ type_ "button"
                , style [ ( "float", "right" ) ]
                , onClick (SubmitAnswer Delete af.id)
                ]
                [ text "Izbriši" ]
            , text " "
            , button
                [ type_ "button"
                , style [ ( "float", "right" ) ]
                , onClick (NewUrl (EditAnswer af.id))
                ]
                [ text "Ažuriraj odgovor" ]
            , div [ style [ ( "clear", "both" ) ] ] []
            , div [ style [ ( "text-align", "left" ) ] ]
                [ Options.styled p
                    [ Typo.body2 ]
                    [ text af.answer
                    ]
                ]
            , br [] []
            ]
        )


answerShow : Answer -> Html Msg
answerShow af =
    let
        formId =
            (toString af.id)

        correctness =
            case af.correct of
                True ->
                    span [ style [ ( "color", "green" ) ] ] [ text "Točno" ]

                False ->
                    span [ style [ ( "color", "red" ) ] ] [ text "Netočno" ]
    in
        div
            [ style
                [ ( "width", "350px" )
                , ( "margin", "0 auto" )
                ]
            ]
            [ span [] [ correctness ]
            , div [ style [ ( "clear", "both" ) ] ] []
            , div []
                [ Options.styled p
                    [ Typo.body2 ]
                    [ text af.answer
                    ]
                ]
            ]


answerTest : Model -> Int -> Answer -> Html Msg
answerTest model index af =
    let
        defaultStyling =
            [ ( "width", "350px" )
            , ( "margin", "0 auto" )
            , ( "transition", "0.3s" )
            , ( "border-radius", "2px" )
            ]

        answerStyle =
            if List.member af model.answeredQuestions then
                let
                    lHead =
                        List.filter (\a -> a.id /= af.id) model.answeredQuestions
                            |> List.head

                    qa =
                        case lHead of
                            Nothing ->
                                emptyAnswer

                            Just qa_ ->
                                qa_

                    colorIt =
                        if af.correct then
                            [ ( "background", "rgba(0, 255, 0, 0.4)" )
                            , ( "color", "#111" )
                            ]
                        else
                            [ ( "background", "rgba(255, 0, 0, 0.4)" )
                            , ( "color", "#111" )
                            ]
                in
                    colorIt
            else
                []
    in
        div
            [ style
                (defaultStyling
                    ++ answerStyle
                )
            ]
            [ grid []
                [ cell [ Material.Grid.size All 2 ] [ checker model af index ]
                , cell [ Material.Grid.size All 10 ]
                    [ Options.styled p
                        [ Typo.body2 ]
                        [ text af.answer
                        ]
                    ]
                ]
            ]


answerExam : Model -> Int -> Answer -> Html Msg
answerExam model index af =
    let
        defaultStyling =
            [ ( "width", "350px" )
            , ( "margin", "0 auto" )
            , ( "transition", "0.3s" )
            , ( "border-radius", "2px" )
            ]
    in
        div
            [ style
                defaultStyling
            ]
            [ grid []
                [ cell [ Material.Grid.size All 2 ] [ checker model af index ]
                , cell [ Material.Grid.size All 10 ]
                    [ Options.styled p
                        [ Typo.body2 ]
                        [ text af.answer
                        ]
                    ]
                ]
            ]


checker : Model -> Answer -> Int -> Html Msg
checker model answer index =
    let
        checkedAnswer =
            if List.member answer model.answeredQuestions then
                True
            else
                False

        letterOrder =
            case index of
                0 ->
                    "a"

                1 ->
                    "b"

                2 ->
                    "c"

                3 ->
                    "d"

                4 ->
                    "e"

                _ ->
                    "a"
    in
        Toggles.checkbox Mdl
            [ answer.id ]
            model.mdl
            [ Options.onToggle (AnswerQuestion answer)
            , Toggles.ripple
            , Toggles.value checkedAnswer
            ]
            [ text <| letterOrder ++ ")" ]
