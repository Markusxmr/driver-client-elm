module Data.UserPhoto exposing (..)

import Html exposing (Attribute)
import Html.Attributes
import Json.Encode as Encode exposing (Value)
import Json.Encode.Extra as EncodeExtra
import Json.Decode as Decode exposing (Decoder)


type UserPhoto
    = UserPhoto (Maybe String)


src : UserPhoto -> Attribute msg
src =
    photoToUrl >> Html.Attributes.src


decoder : Decoder UserPhoto
decoder =
    Decode.map UserPhoto (Decode.nullable Decode.string)


encode : UserPhoto -> Value
encode (UserPhoto maybeUrl) =
    EncodeExtra.maybe Encode.string maybeUrl


toMaybeString : UserPhoto -> Maybe String
toMaybeString (UserPhoto maybeUrl) =
    maybeUrl


photoToUrl : UserPhoto -> String
photoToUrl (UserPhoto maybeUrl) =
    case maybeUrl of
        Nothing ->
            "https://static.productionready.io/images/smiley-cyrus.jpg"

        Just url ->
            url
