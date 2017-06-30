module View.Q exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Lazy exposing (lazy)
import Model exposing (Model)
import Data.Question exposing (Question)
import Data.DeleteVariant exposing (DeleteType(QuestionDelete))
import Message exposing (Msg(NewUrl, ConfirmDelete))
import Routes exposing (Route(..))
import Material.Grid exposing (grid, cell, size, Device(..))
import Material.Options as Options exposing (when)
import Material.Typography as Typo
import View.CButton as CButton
import Helpers exposing (userModeHidden)


listQuestions : Model -> Html Msg
listQuestions model =
    grid []
        [ cell
            [ Material.Grid.offset Desktop 2
            , Material.Grid.size Desktop 8
            , Material.Grid.size Tablet 12
            , Material.Grid.size Phone 12
            ]
            [ lazy questionsAnswers model
            ]
        ]


listQuestionsShow : Model -> Html Msg
listQuestionsShow model =
    grid []
        [ cell
            [ Material.Grid.offset Desktop 2
            , Material.Grid.size Desktop 8
            , Material.Grid.size Tablet 12
            , Material.Grid.size Phone 12
            ]
            [ lazy questionsAnswersShow model
            ]
        ]


questionAnswer : Model -> Int -> Question -> List (Material.Grid.Cell Msg)
questionAnswer model index question =
    [ qCellLeft question
    , qCellRight model question
    ]


questionsAnswers : Model -> Html Msg
questionsAnswers model =
    div []
        [ CButton.view model -1 NewQuestion "Dodaj pitanje"
        , br [] []
        , br [] []
        , List.indexedMap (questionAnswer model) (sortBy model.questions)
            |> concatAndGrid
        ]


questionAnswerShow : Model -> Int -> Question -> List (Material.Grid.Cell Msg)
questionAnswerShow model index question =
    [ cell
        [ Material.Grid.size Desktop 6
        , Material.Grid.size Tablet 12
        , Material.Grid.size Phone 12
        , Options.css "text-align" "left"
        ]
        [ Options.styled span
            [ Options.onClick (NewUrl <| ShowQuestion question.id)
            , Typo.left
            ]
            [ span
                [ style [ ( "cursor", "pointer" ) ] ]
                [ text <| (toString question.question_num) ++ ". " ++ question.question ]
            , text " "
            ]
        ]
    ]


questionsAnswersShow : Model -> Html Msg
questionsAnswersShow model =
    div []
        [ br [] []
        , List.indexedMap (questionAnswerShow model) (sortBy model.questions)
            |> concatAndGrid
        ]


sortBy : List Question -> List Question
sortBy questions =
    List.sortBy .question_num questions


concatAndGrid : List (List (Material.Grid.Cell a)) -> Html a
concatAndGrid list =
    list
        |> List.concat
        |> grid []


qCellLeft : Question -> Material.Grid.Cell Msg
qCellLeft question =
    cell
        [ Material.Grid.size Desktop 4
        , Material.Grid.size Tablet 8
        , Material.Grid.size Phone 8
        , Options.css "text-align" "left"
        ]
        [ Options.styled span
            [ Options.onClick (NewUrl <| ShowQuestion question.id)
            , Typo.left
            ]
            [ span
                [ style [ ( "cursor", "pointer" ) ] ]
                [ text <| (toString question.question_num) ++ ". " ++ question.question ]
            , text " "
            ]
        ]


qCellRight : Model -> Question -> Material.Grid.Cell Msg
qCellRight model question =
    cell
        [ Material.Grid.size Desktop 2
        , Material.Grid.size Tablet 4
        , Material.Grid.size Phone 4
        , Options.css "text-align" "right"
        ]
        [ span [ hidden (userModeHidden model) ]
            [ button
                [ type_ "button"
                , onClick (NewUrl <| EditQuestion question.id)
                ]
                [ text "Ažuriraj" ]
            , text " "
            , button
                [ type_ "button"
                , onClick (ConfirmDelete question.id QuestionDelete)
                ]
                [ text "Izbriši" ]
            ]
        ]
