module Page.Questions.New exposing (..)

import Html exposing (..)
import Html.Lazy exposing (lazy)
import Html.Events exposing (onClick, onSubmit, onInput)
import Model exposing (Model, QuestionChange(..), UserMode(..), AnswerChange(FormAnswer), Submit(Create))
import Data.Answer exposing (AnswerForm)
import Message exposing (Msg(InputQuestionForm, SubmitQuestion, NewUrl, Upload))
import View.FormButtons as FormButtons
import View.ChapterSelect as ChapterSelect
import Routes exposing (Route(ShowChapter, EditChapter))
import View.CTextfield as CTextfield


view : Model -> Html Msg
view model =
    div []
        [ Html.form [ onSubmit (SubmitQuestion Create) ]
            [ br [] []
            , ChapterSelect.viewNew model
            , h3 [] [ text <| (toString model.questionForm.question_num) ++ ". " ++ model.questionForm.question ]
            , br [] []
            , lazy newQuestionNumInput model
            , br [] []
            , lazy newInput model
            , br [] []
            , showOrEdit model
            , br [] []
            ]
        ]


newQuestionNumInput : Model -> Html Msg
newQuestionNumInput model =
    div []
        [ text "Unesi redni broj pitanja: "
        , br [] []
        , CTextfield.view
            model
            (toString model.questionForm.question_num)
            1
            "Broj pitanja"
            (InputQuestionForm FormQuestionNum)
        ]


newInput : Model -> Html Msg
newInput model =
    div []
        [ text "Unesi pitanje"
        , br [] []
        , CTextfield.view
            model
            model.questionForm.question
            2
            "Pitanje"
            (InputQuestionForm FormQuestion)
        ]


showOrEdit : Model -> Html Msg
showOrEdit model =
    case model.userMode of
        Show ->
            FormButtons.view model (ShowChapter model.questionForm.chapter_id)

        Admin ->
            FormButtons.view model (EditChapter model.questionForm.chapter_id)
