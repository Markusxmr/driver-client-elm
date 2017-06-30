module View.NavigateButtons exposing (..)

import Html exposing (..)
import Model exposing (Model)
import Message exposing (Msg(NoOp, SubmitAnsweredQuestion, NewUrl, Mdl, PrevQuestion, NextQuestion, FinishExam))
import Material.Button as Button
import Material.Options as Options exposing (when)


view : Model -> Html Msg
view model =
    div []
        [ prevButton model
        , text " "
        , nextButton model
        ]


prevButton : Model -> Html Msg
prevButton model =
    Button.render Mdl
        [ 3, 2, 1 ]
        model.mdl
        [ Button.raised
        , Button.colored
        , Button.ripple
        , Button.type_ "button"
        , Options.onClick PrevQuestion
        ]
        [ text "Prethodno"
        ]


nextButton : Model -> Html Msg
nextButton model =
    Button.render Mdl
        [ 3, 2, 2 ]
        model.mdl
        [ Button.raised
        , Button.colored
        , Button.ripple
        , Button.type_ "submit"
        , Options.onClick NextQuestion
        ]
        [ text "Slijedeće"
        ]


finishedButton : Model -> Html Msg
finishedButton model =
    Button.render Mdl
        [ 3, 2, 2 ]
        model.mdl
        [ Button.raised
        , Button.colored
        , Button.ripple
        , Button.type_ "submit"
        , Options.onClick FinishExam
        ]
        [ text "Završi"
        ]


answerButton : Model -> Html Msg
answerButton model =
    let
        buttonText =
            if List.length model.questions == model.questionExam.question_num then
                "Završi"
            else
                "Odgovori"
    in
        Button.render Mdl
            [ 3, 2, 3 ]
            model.mdl
            [ Button.raised
            , Button.colored
            , Button.ripple
            , Button.type_ "submit"
            , Options.onClick SubmitAnsweredQuestion
            ]
            [ text buttonText
            ]


infoButton : Model -> Html Msg
infoButton model =
    let
        correct =
            case model.answerInfo of
                Nothing ->
                    ""

                Just a ->
                    if a then
                        "Točno"
                    else
                        "Netočno"
    in
        Button.render Mdl
            [ 3, 2, 4 ]
            model.mdl
            [ Button.raised
            , Button.colored
            , Button.ripple
            , Button.type_ "submit"
            , Options.onClick NoOp
            ]
            [ text correct
            ]
