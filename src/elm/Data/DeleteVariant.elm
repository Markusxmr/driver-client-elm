module Data.DeleteVariant exposing (..)

import Json.Decode as Decode exposing (Decoder, field)


type alias DeleteVariant =
    { id : Int
    , deleteType : String
    }


type DeleteType
    = ChapterDelete
    | QuestionDelete
    | AnswerDelete
    | Unknown


decoder : String -> Decoder DeleteVariant
decoder dt =
    Decode.map2 DeleteVariant
        (field "id" Decode.int)
        (field "deleteType" Decode.string)


decodeDeleteType : String -> Decoder DeleteType
decodeDeleteType dt =
    Decode.succeed (deleteType dt)


deleteType : String -> DeleteType
deleteType dt =
    case (String.toLower dt) of
        "chapterdelete" ->
            ChapterDelete

        "questiondelete" ->
            QuestionDelete

        "answerdelete" ->
            AnswerDelete

        _ ->
            Unknown
