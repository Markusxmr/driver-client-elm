module Page.Answers.Show exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Routes exposing (Route(Chapters))
import Message exposing (Msg(NewUrl))


view : Model -> Html Msg
view model =
    div []
        [ br [] []
        , button [ type_ "button", onClick (NewUrl Chapters) ]
            [ text "Natrag" ]
        , br [] []
        , h3 [] [ text <| (toString model.chapterForm.chapter_num) ++ ". " ++ model.chapterForm.name ]
        ]
