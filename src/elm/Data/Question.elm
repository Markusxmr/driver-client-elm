module Data.Question exposing (..)

import Json.Decode as Decode exposing (Decoder, field, string, int, bool)
import Json.Encode as Encode exposing (Value)


type alias Question =
    { id : Int
    , chapter_id : Int
    , question_num : Int
    , image : String
    , question : String
    }


type alias QuestionForm =
    { id : Int
    , chapter_id : Int
    , question_num : Int
    , image : String
    , question : String
    }


type alias Data a =
    { data : a }


type alias QuestionsData =
    { data : List Question }


initQuestion : Question
initQuestion =
    { id = 0
    , chapter_id = 0
    , question_num = 0
    , image = ""
    , question = ""
    }


initQuestionForm : QuestionForm
initQuestionForm =
    { id = 0
    , chapter_id = 0
    , question_num = 0
    , image = ""
    , question = ""
    }


decodeData : Decoder a -> Decoder (Data a)
decodeData decode =
    Decode.map Data
        (field "data" decode)


decodeQuestions : Decoder QuestionsData
decodeQuestions =
    Decode.map QuestionsData
        (field "data" <| Decode.list <| decodeQuestion)


decodeQuestion : Decoder Question
decodeQuestion =
    Decode.map5 Question
        (field "id" int)
        (field "chapter_id" int)
        (field "question_num" int)
        (field "image" string)
        (field "question" string)


encodeQuestion : QuestionForm -> Value
encodeQuestion qForm =
    let
        content =
            Encode.object
                [ ( "chapter_id", Encode.int qForm.chapter_id )
                , ( "question_num", Encode.int qForm.question_num )
                , ( "question", Encode.string qForm.question )
                ]

        object =
            Encode.object
                [ ( "question"
                  , content
                  )
                ]
    in
        object
