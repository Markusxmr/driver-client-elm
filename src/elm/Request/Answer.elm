module Request.Answer exposing (..)

import Data.AuthToken exposing (AuthToken, withAuthorizationDefault)
import Data.Answer exposing (..)
import Http exposing (Error)
import Request.RequestHelpers exposing (baseUrl)


getAnswers : (Result Error AnswersData -> msg) -> Cmd msg
getAnswers msg =
    Http.get (baseUrl ++ "api/answers/") decodeAnswers
        |> Http.send msg


getAnswersByQuestionId : String -> (Result Error AnswersData -> msg) -> Cmd msg
getAnswersByQuestionId id msg =
    Http.get (baseUrl ++ "api/answers_by_question_id/" ++ id) decodeAnswers
        |> Http.send msg


getAnswer : String -> (Result Error (Data Answer) -> msg) -> Cmd msg
getAnswer id msg =
    Http.get (baseUrl ++ "api/answers/" ++ id) (decodeData decodeAnswer)
        |> Http.send msg


createAnswer : AnswerForm -> Maybe AuthToken -> (Result Error (Data Answer) -> msg) -> Cmd msg
createAnswer aForm maybeToken msg =
    let
        body =
            encodeAnswer aForm
                |> Http.jsonBody

        config =
            Http.request
                { method = "POST"
                , headers = withAuthorizationDefault maybeToken
                , url = (baseUrl ++ "admin_api/answers")
                , body = body
                , expect = Http.expectJson (decodeData decodeAnswer)
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send msg <| config


updateAnswer : String -> AnswerForm -> Maybe AuthToken -> (Result Error (Data Answer) -> msg) -> Cmd msg
updateAnswer id aForm maybeToken msg =
    let
        body =
            encodeAnswer aForm
                |> Http.jsonBody

        config =
            Http.request
                { method = "PUT"
                , headers = withAuthorizationDefault maybeToken
                , url = (baseUrl ++ "admin_api/answers/" ++ id)
                , body = body
                , expect = Http.expectJson (decodeData decodeAnswer)
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send msg <| config


deleteAnswer : String -> Maybe AuthToken -> (Result Error (Data Answer) -> msg) -> Cmd msg
deleteAnswer id maybeToken msg =
    let
        config =
            Http.request
                { method = "DELETE"
                , headers = withAuthorizationDefault maybeToken
                , url = (baseUrl ++ "admin_api/answers/" ++ id)
                , body = Http.emptyBody
                , expect = Http.expectJson (decodeData decodeAnswer)
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send msg <| config
