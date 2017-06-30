module View.ChapterSelect exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Model exposing (Model, QuestionChange(FormChapterId))
import Data.Chapter exposing (Chapter)
import Message exposing (Msg(NewUrl, InputQuestionForm))


view : Model -> Html Msg
view model =
    let
        chapterId =
            model.questionForm.chapter_id

        chapterMaybe =
            model.chapters
                |> List.filter (\a -> a.id == chapterId)
                |> List.head

        chapter =
            case chapterMaybe of
                Nothing ->
                    option [] [ text "Izaberi poglavlje" ]

                Just c ->
                    option [] [ text <| (toString c.chapter_num) ++ ". " ++ c.name ]
    in
        div []
            [ select [ onInput (InputQuestionForm FormChapterId) ] <|
                chapter
                    :: List.map (\c -> chapterOption c) model.chapters
            ]


extractChapter : Model -> String -> Html msg
extractChapter model view =
    let
        chapterId =
            case model.chapter of
                Nothing ->
                    0

                Just chapter ->
                    chapter.id

        chapterMaybe =
            model.chapters
                |> List.filter (\a -> a.id == chapterId)
                |> List.head

        show =
            case chapterMaybe of
                Nothing ->
                    h6 []
                        [ text "Izaberi poglavlje"
                        ]

                Just c ->
                    h6 []
                        [ text <| (toString c.chapter_num) ++ ". " ++ c.name
                        ]

        chapter =
            case view of
                "edit" ->
                    case chapterMaybe of
                        Nothing ->
                            option [] [ text "Izaberi poglavlje" ]

                        Just c ->
                            option [] [ text <| (toString c.chapter_num) ++ ". " ++ c.name ]

                "show" ->
                    show

                _ ->
                    show
    in
        chapter


viewShow : Model -> Html msg
viewShow model =
    extractChapter model "view"


viewNew : Model -> Html Msg
viewNew model =
    div []
        [ select [ onInput (InputQuestionForm FormChapterId) ] <|
            extractChapter model "edit"
                :: List.map (\c -> chapterOption c) model.chapters
        ]


chapterOption : Chapter -> Html msg
chapterOption c =
    option [ value <| toString c.id ] [ text <| (toString c.chapter_num) ++ ". " ++ c.name ]
