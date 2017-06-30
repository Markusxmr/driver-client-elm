module View.AnswerForm exposing (..)

import Html exposing (..)
import Html.Lazy exposing (lazy2)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Model exposing (Model, AnswerChange(FormAnswer), Submit(Create))
import Data.Answer exposing ( AnswerForm)
import Message exposing (Msg(InputAnswerForm, SubmitAnswer, CheckTruthiness, Mdl))
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Toggles as Toggles


view : Model -> Html Msg
view model =
    div []
        [ lazy2 answer model model.answerForm ]


answer : Model -> AnswerForm -> Html Msg
answer model af =
    let
        formId =
            (toString af.form_id)

        radioChecked =
            case af.correct of
                True ->
                    div []
                        [ mdlRadio ( model, af.form_id, True, "Točno" )
                        , text " | "
                        , mdlRadio ( model, af.form_id, False, "Netočno" )
                        ]

                False ->
                    div []
                        [ mdlRadio ( model, af.form_id, False, "Točno" )
                        , text " | "
                        , mdlRadio ( model, af.form_id, True, "Netočno" )
                        ]
    in
        div []
            [ h5 [] [ span [] [ text <| toString af.correct ++ " " ], text formId ]
            , radioChecked
            , div []
                [ cTextarea model af.answer "Odgovor" (InputAnswerForm FormAnswer af.form_id)

                {- }, textarea
                   [ rows 7
                   , cols 34
                   , value af.answer
                   , onInput (InputAnswerForm FormAnswer af.form_id)
                   ]
                   []
                -}
                ]
            , br [] []
            ]


cTextarea : Model -> String -> String -> (String -> Msg) -> Html Msg
cTextarea model value label msg =
    Textfield.render Mdl
        [ 1 ]
        model.mdl
        [ Textfield.label label
        , Textfield.textarea
        , Textfield.rows 7
        , Textfield.value value
        , Options.onInput msg
        ]
        []


labelElement : ( Int, Bool, String ) -> Html Msg
labelElement ( formId, isChecked, txt ) =
    let
        boolType =
            case txt of
                "Točno" ->
                    True

                "Netočno" ->
                    False

                _ ->
                    False
    in
        label []
            [ input
                [ type_ "radio"
                , name <| "correctness" ++ (toString formId)
                , checked isChecked
                , value <| toString isChecked
                , onClick (CheckTruthiness ( formId, boolType ))
                ]
                []
            , text txt
            ]


mdlRadio : ( Model, Int, Bool, String ) -> Html Msg
mdlRadio ( model, formId, isChecked, txt ) =
    let
        boolType =
            case txt of
                "Točno" ->
                    True

                "Netočno" ->
                    False

                _ ->
                    False
    in
        Toggles.radio Mdl
            [ 0 ]
            model.mdl
            [ Toggles.value isChecked
            , Toggles.group <| "correctness" ++ (toString formId)
            , Toggles.ripple
            , Options.onToggle (CheckTruthiness ( formId, boolType ))
            ]
            [ text txt ]
