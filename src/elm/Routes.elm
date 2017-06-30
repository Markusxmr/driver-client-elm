module Routes exposing (..)

import UrlParser as Url exposing ((</>), (<?>), s, int, stringParam, top)
import Navigation


type Route
    = Home
    | Login
    | Logout
    | Learn Int Int
    | Chapters
    | NewChapter
    | ShowChapter Int
    | EditChapter Int
    | ShowQuestion Int
    | NewQuestion
    | EditQuestion Int
    | Answers
    | NewAnswer Int
    | EditAnswer Int
    | Tests Int Int
    | Exams Int Int


parseRoute : Url.Parser (Route -> a) a
parseRoute =
    Url.oneOf
        [ Url.map Home top
        , Url.map Login (s "login")
        , Url.map Logout (s "logout")
        , Url.map Learn (s "learn" </> Url.int </> Url.int)
        , Url.map Tests (s "tests" </> Url.int </> Url.int)
        , Url.map Exams (s "exams" </> Url.int </> Url.int)
        , Url.map Chapters (s "chapters")
        , Url.map NewChapter (s "chapters" </> s "new")
        , Url.map ShowChapter (s "chapters" </> Url.int)
        , Url.map EditChapter (s "chapters" </> Url.int </> s "edit")
        , Url.map ShowQuestion (s "questions" </> Url.int)
        , Url.map NewQuestion (s "questions" </> s "new")
        , Url.map EditQuestion (s "questions" </> Url.int </> s "edit")
        , Url.map NewAnswer (s "answers" </> Url.int </> s "new")
        , Url.map EditAnswer (s "answers" </> Url.int </> s "edit")
        , Url.map Answers (s "answers")
        , Url.map Home (s "home")
        ]


parseLocation : Navigation.Location -> Route
parseLocation location =
    case (Url.parseHash parseRoute location) of
        Just route ->
            route

        Nothing ->
            Home


decode : Navigation.Location -> Maybe Route
decode location =
    Url.parseHash parseRoute location


modifyUrl : Route -> Cmd msg
modifyUrl =
    urlFor >> Navigation.modifyUrl


urlFor : Route -> String
urlFor route =
    case route of
        Home ->
            "#"

        Login ->
            "login"

        Logout ->
            "logout"

        Learn chapterId questionNum ->
            "learn/" ++ (toString chapterId) ++ "/" ++ (toString questionNum)

        Tests chapterId questionNum ->
            "tests/" ++ (toString chapterId) ++ "/" ++ (toString questionNum)

        Exams chapterId questionNum ->
            "exams/" ++ (toString chapterId) ++ "/" ++ (toString questionNum)

        NewChapter ->
            "chapters/new"

        ShowChapter id ->
            "chapters/" ++ (toString id)

        EditChapter id ->
            "chapters/" ++ (toString id) ++ "/edit"

        Chapters ->
            "chapters"

        ShowQuestion id ->
            "questions/" ++ (toString id)

        NewQuestion ->
            "questions/new"

        EditQuestion id ->
            "questions/" ++ (toString id) ++ "/edit"

        NewAnswer id ->
            "answers/" ++ (toString id) ++ "/new"

        EditAnswer id ->
            "answers/" ++ (toString id) ++ "/edit"

        Answers ->
            "answers"
