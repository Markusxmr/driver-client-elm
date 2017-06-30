module Data.Chapter exposing (..)

import Json.Decode as Decode exposing (Decoder, field, string, int, bool)
import Json.Encode as Encode exposing (Value)


type alias Chapter =
    { id : Int
    , chapter_num : Int
    , name : String
    }


type alias ChapterForm =
    { chapter_num : Int
    , name : String
    }


type alias Data a =
    { data : a }


type alias ChaptersData =
    { data : List Chapter }



initChapterForm : ChapterForm
initChapterForm =
    { chapter_num = 0
    , name = ""
    }

decodeData : Decoder a -> Decoder (Data a)
decodeData decode =
    Decode.map Data
        (field "data" decode)


decodeChapters : Decoder ChaptersData
decodeChapters =
    Decode.map ChaptersData
        (field "data" <| Decode.list <| decodeChapter)


decodeChapter : Decoder Chapter
decodeChapter =
    Decode.map3 Chapter
        (field "id" int)
        (field "chapter_num" int)
        (field "name" string)


encodeChapter : ChapterForm -> Value
encodeChapter cForm =
    let
        content =
            Encode.object
                [ ( "chapter_num", Encode.int cForm.chapter_num )
                , ( "name", Encode.string cForm.name )
                ]

        object =
            Encode.object
                [ ( "chapter"
                  , content
                  )
                ]
    in
        object
