module Request.Chapter exposing (..)

import Data.AuthToken exposing (AuthToken, withAuthorizationDefault)
import Data.Chapter exposing (..)
import Http exposing (Error)
import Request.RequestHelpers exposing (baseUrl)
import Json.Decode as Decode exposing (Decoder)


httpGet : Decoder a -> (Result Error a -> msg) -> Cmd msg
httpGet decoder msg =
    let
        config =
            Http.request
                { method = "GET"
                , headers = []
                , url = (baseUrl ++ "api/chapters")
                , body = Http.emptyBody
                , expect = Http.expectJson decoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send msg <| config


getChapters : (Result Error ChaptersData -> msg) -> Cmd msg
getChapters msg =
    httpGet decodeChapters msg


getChapter : String -> (Result Error (Data Chapter) -> msg) -> Cmd msg
getChapter id msg =
    let
        config =
            Http.request
                { method = "GET"
                , headers = []
                , url = (baseUrl ++ "api/chapters/" ++ id)
                , body = Http.emptyBody
                , expect = Http.expectJson (decodeData decodeChapter)
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send msg <| config


createChapter : ChapterForm -> Maybe AuthToken -> (Result Error (Data Chapter) -> msg) -> Cmd msg
createChapter cForm maybeToken msg =
    let
        body =
            encodeChapter cForm
                |> Http.jsonBody

        config =
            Http.request
                { method = "POST"
                , headers = withAuthorizationDefault maybeToken
                , url = (baseUrl ++ "admin_api/chapters")
                , body = body
                , expect = Http.expectJson (decodeData decodeChapter)
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send msg <| config


updateChapter : String -> ChapterForm -> Maybe AuthToken -> (Result Error (Data Chapter) -> msg) -> Cmd msg
updateChapter id cForm maybeToken msg =
    let
        body =
            encodeChapter cForm
                |> Http.jsonBody

        config =
            Http.request
                { method = "PUT"
                , headers = withAuthorizationDefault maybeToken
                , url = (baseUrl ++ "admin_api/chapters/" ++ id)
                , body = body
                , expect = Http.expectJson (decodeData decodeChapter)
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send msg <| config


deleteChapter : String -> Maybe AuthToken -> (Result Error (Data Chapter) -> msg) -> Cmd msg
deleteChapter id maybeToken msg =
    let
        config =
            Http.request
                { method = "DELETE"
                , headers = withAuthorizationDefault maybeToken
                , url = (baseUrl ++ "admin_api/chapters/" ++ id)
                , body = Http.emptyBody
                , expect = Http.expectJson (decodeData decodeChapter)
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send msg <| config
