module Page.Questions.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onSubmit, onInput)
import Model exposing (Model, QuestionChange(..), UserMode(..), AnswerChange(FormAnswer), Submit(Update))
import Data.Answer exposing (AnswerForm)
import Message exposing (Msg(InputQuestionForm, InputAnswerForm, NewUrl, SubmitQuestion, InputChapterForm, Upload))
import View.FormButtons as FormButtons
import View.ChapterSelect as ChapterSelect
import View.AnswerList as AnswerList
import Routes exposing (Route(ShowChapter, EditChapter, NewAnswer, EditAnswer))
import View.CTextfield as CTextfield
import Material.Grid exposing (grid, cell, size, Device(..))


view : Model -> Html Msg
view model =
    div []
        [ Html.form [ onSubmit (SubmitQuestion Update) ]
            [ br [] []
            , showOrEdit model
            , br [] []
            , ChapterSelect.view model
            , h5 []
                [ text <| toString model.questionForm.question_num ++ ". " ++ model.questionForm.question
                ]
            , br [] []
            , grid [ Material.Grid.offset Desktop 4 ]
                [ cell
                    [ Material.Grid.size Desktop 2
                    , Material.Grid.size Tablet 4
                    , Material.Grid.size Phone 4
                    ]
                    [ div []
                        [ br [] []
                        , CTextfield.view
                            model
                            (toString model.questionForm.question_num)
                            1
                            "Broj pitanja"
                            (InputQuestionForm FormQuestionNum)
                        ]
                    ]
                , cell
                    [ Material.Grid.size Desktop 4
                    , Material.Grid.size Tablet 12
                    , Material.Grid.size Phone 12
                    ]
                    [ div []
                        [ text "Pitanje:"
                        , br [] []
                        , CTextfield.view
                            model
                            model.questionForm.question
                            2
                            "Pitanje"
                            (InputQuestionForm FormQuestion)
                        ]
                    ]
                ]
            , br [] []
            , grid [ Material.Grid.offset Desktop 2 ]
                [ cell
                    [ Material.Grid.size Desktop 3
                    , Material.Grid.size Tablet 12
                    , Material.Grid.size Phone 12
                    ]
                    [ div []
                        [ text "Slika"
                        , br [] []
                        , input
                            [ type_ "file"
                            , id <| "question-image-" ++ (toString model.questionForm.id)
                            , name <| "question-image-" ++ (toString model.questionForm.id)
                            ]
                            []
                        ]
                    , div []
                        [ img [ src model.questionForm.image, width 400 ] []
                        ]
                    , div []
                        [ button
                            [ type_ "button"
                            , onClick (Upload model.questionForm.id)
                            ]
                            [ text "Upload" ]
                        ]
                    ]
                , cell
                    [ Material.Grid.size Desktop 7
                    , Material.Grid.size Tablet 12
                    , Material.Grid.size Phone 12
                    ]
                    [ text "Odgovori:"
                    , AnswerList.view model
                    , br [] []
                    , div []
                        [ button
                            [ type_ "button"
                            , onClick <| NewUrl (NewAnswer model.questionForm.id)
                            ]
                            [ text "Dodaj odgovor" ]
                        ]
                    , br [] []
                    ]
                ]
            , showOrEdit model
            , br [] []
            , br [] []
            ]
        ]


showOrEdit : Model -> Html Msg
showOrEdit model =
    case model.userMode of
        Show ->
            FormButtons.view model (ShowChapter model.questionForm.chapter_id)

        Admin ->
            FormButtons.view model (EditChapter model.questionForm.chapter_id)
