module Data.Login exposing (..)

import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode exposing (Decoder, field, string)


type alias LoginFields =
    { email : String
    , password : String
    }


initLoginFields : LoginFields
initLoginFields =
    { email = ""
    , password = ""
    }


decoder : Decoder LoginFields
decoder =
    Decode.map2 LoginFields
        (field "email" string)
        (field "password" string)


encode : LoginFields -> Value
encode login =
    Encode.object
        [ ( "email", Encode.string login.email )
        , ( "password", Encode.string login.password )
        ]
