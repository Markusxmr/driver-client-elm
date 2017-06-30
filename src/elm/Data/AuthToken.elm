module Data.AuthToken exposing (..)

import HttpBuilder exposing (RequestBuilder, withHeader)
import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode exposing (Decoder, string, int)
import Http


type AuthToken
    = AuthToken String


encode : AuthToken -> Value
encode (AuthToken token) =
    Encode.string token


decoder : Decoder AuthToken
decoder =
    Decode.map AuthToken string


withAuthorization : Maybe AuthToken -> RequestBuilder a -> RequestBuilder a
withAuthorization maybeToken builder =
    case maybeToken of
        Just (AuthToken token) ->
            builder
                |> withHeader "authorization" ("Token " ++ token)

        Nothing ->
            builder


withAuthorizationDefault : Maybe AuthToken -> List Http.Header
withAuthorizationDefault maybeToken =
    case maybeToken of
        Just (AuthToken token) ->
            [ Http.header "Authorization" ("Token " ++ token) ]

        Nothing ->
            []
