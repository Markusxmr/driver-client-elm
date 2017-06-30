module Data.Answer exposing (..)

import Data.Question exposing (Question)
import Json.Decode as Decode exposing (Decoder, field, string, int, bool)
import Json.Encode as Encode exposing (Value)


type alias ExamAnswer =
    { question : Question
    , questionAnswers : List Answer
    , correct : Bool
    }


type alias Answer =
    { id : Int
    , question_id : Int
    , answer : String
    , correct : Bool
    }


type alias AnswerForm =
    { form_id : Int
    , question_id : Int
    , answer : String
    , correct : Bool
    }


type alias Data a =
    { data : a }


type alias AnswersData =
    { data : List Answer }


emptyAnswer : Answer
emptyAnswer =
    { id = 0
    , question_id = 0
    , answer = ""
    , correct = False
    }


initAnswerForm : AnswerForm
initAnswerForm =
    { form_id = 0
    , question_id = 0
    , answer = ""
    , correct = False
    }


decodeData : Decoder a -> Decoder (Data a)
decodeData decode =
    Decode.map Data
        (field "data" decode)


decodeAnswers : Decoder AnswersData
decodeAnswers =
    Decode.map AnswersData
        (field "data" <| Decode.list <| decodeAnswer)


decodeAnswer : Decoder Answer
decodeAnswer =
    Decode.map4 Answer
        (field "id" int)
        (field "question_id" int)
        (field "answer" string)
        (field "correct" bool)


encodeAnswers : List AnswerForm -> Value
encodeAnswers answers =
    let
        objectList =
            List.map (\a -> encodeAnswer a) answers
                |> Encode.list

        object =
            Encode.object
                [ ( "answer", objectList )
                ]
    in
        object


encodeAnswer : AnswerForm -> Value
encodeAnswer aForm =
    let
        content =
            Encode.object
                [ ( "question_id", Encode.int aForm.question_id )
                , ( "answer", Encode.string aForm.answer )
                , ( "correct", Encode.bool aForm.correct )
                ]

        object =
            Encode.object
                [ ( "answer", content )
                ]
    in
        object
