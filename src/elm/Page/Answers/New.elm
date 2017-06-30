module Page.Answers.New exposing (..)

import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Model exposing (Model, ChapterChange(..), UserMode(..), Submit(Create))
import Message exposing (Msg(SubmitAnswer))
import View.FormButtons as FormButtons
import View.AnswerForm as AnswerForm
import Routes exposing (Route(EditQuestion, ShowQuestion))


view : Model -> Html Msg
view model =
    div []
        [ Html.form [ onSubmit (SubmitAnswer Create model.questionForm.id) ]
            [ h3 []
                [ text <| toString model.questionForm.question_num ++ ". " ++ model.questionForm.question
                ]
            , AnswerForm.view model
            , br [] []
            , FormButtons.view model (EditQuestion model.questionForm.id)
            ]
        ]


showOrEdit : Model -> Html Msg
showOrEdit model =
    case model.userMode of
        Show ->
            FormButtons.view model (ShowQuestion model.questionForm.id)

        Admin ->
            FormButtons.view model (EditQuestion model.questionForm.id)
