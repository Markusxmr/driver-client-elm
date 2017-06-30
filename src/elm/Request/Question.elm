module Request.Question exposing (..)

import Data.AuthToken exposing (AuthToken, withAuthorizationDefault)
import Data.Question exposing (..)
import Http exposing (Error)
import Request.RequestHelpers exposing (baseUrl)


getQuestions : (Result Error QuestionsData -> msg) -> Cmd msg
getQuestions msg =
    Http.get (baseUrl ++ "api/questions/") decodeQuestions
        |> Http.send msg


getQuestion : String -> (Result Error (Data Question) -> msg) -> Cmd msg
getQuestion id msg =
    Http.get (baseUrl ++ "api/questions/" ++ id) (decodeData decodeQuestion)
        |> Http.send msg


getQuestionsByChapterId : String -> (Result Error QuestionsData -> msg) -> Cmd msg
getQuestionsByChapterId id msg =
    Http.get (baseUrl ++ "api/questions_by_chapter_id/" ++ id) decodeQuestions
        |> Http.send msg


createQuestion : QuestionForm -> Maybe AuthToken -> (Result Error (Data Question) -> msg) -> Cmd msg
createQuestion qForm maybeToken msg =
    let
        body =
            encodeQuestion qForm
                |> Http.jsonBody

        config =
            Http.request
                { method = "POST"
                , headers = withAuthorizationDefault maybeToken
                , url = (baseUrl ++ "admin_api/questions")
                , body = body
                , expect = Http.expectJson (decodeData decodeQuestion)
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send msg <| config


updateQuestion : String -> QuestionForm -> Maybe AuthToken -> (Result Error (Data Question) -> msg) -> Cmd msg
updateQuestion id qForm maybeToken msg =
    let
        body =
            encodeQuestion qForm
                |> Http.jsonBody

        config =
            Http.request
                { method = "PUT"
                , headers = withAuthorizationDefault maybeToken
                , url = (baseUrl ++ "admin_api/questions/" ++ id)
                , body = body
                , expect = Http.expectJson (decodeData decodeQuestion)
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send msg <| config


deleteQuestion : String -> Maybe AuthToken -> (Result Error (Data Question) -> msg) -> Cmd msg
deleteQuestion id maybeToken msg =
    let
        config =
            Http.request
                { method = "DELETE"
                , headers = withAuthorizationDefault maybeToken
                , url = (baseUrl ++ "admin_api/questions/" ++ id)
                , body = Http.emptyBody
                , expect = Http.expectJson (decodeData decodeQuestion)
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send msg <| config
