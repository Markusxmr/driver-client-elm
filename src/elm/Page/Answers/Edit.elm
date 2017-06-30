module Page.Answers.Edit exposing (..)

import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Model exposing (Model, ChapterChange(..), UserMode(..), Submit(Update))
import Message exposing (Msg(SubmitAnswer))
import View.FormButtons as FormButtons
import View.AnswerForm as AnswerForm
import Routes exposing (Route(EditQuestion, ShowQuestion))


view : Model -> Int -> Html Msg
view model answerId =
    div []
        [ Html.form [ onSubmit (SubmitAnswer Update answerId) ]
            [ h3 []
                [ text <| toString model.questionForm.question_num ++ ". " ++ model.questionForm.question
                ]
            , AnswerForm.view model
            , br [] []
            , showOrEdit model
            ]
        ]


showOrEdit : Model -> Html Msg
showOrEdit model =
    case model.userMode of
        Show ->
            FormButtons.view model (ShowQuestion model.questionForm.id)

        Admin ->
            FormButtons.view model (EditQuestion model.questionForm.id)
