module View exposing (..)

import Html exposing (..)
import Html.Lazy exposing (lazy)
import Model exposing (Model)
import Message exposing (Msg(LoginMsg))
import Routes exposing (Route(..))
import View.Page as Page
import Page.Login as PageLogin
import Page.Logout as Logout
import Page.Home.Home as HomePage
import Page.Learn.Show as LShow
import Page.Tests.Show as TShow
import Page.Exams.Show as EShow
import Page.Chapters.ChapterList as CList
import Page.Chapters.New as CNew
import Page.Chapters.Show as CShow
import Page.Chapters.Edit as CEdit
import Page.Questions.New as QNew
import Page.Questions.Show as QShow
import Page.Questions.Edit as QEdit
import Page.Answers.New as ANew
import Page.Answers.Edit as AEdit
import View.Q as Q


currentRoute : Model -> Maybe Route
currentRoute model =
    List.head model.history
        |> Maybe.withDefault Nothing


routeView : Model -> Html Msg
routeView model =
    case currentRoute model of
        Just route ->
            let
                viewRoute =
                    case model.session.user of
                        Nothing ->
                            publicRoutes model route

                        Just session ->
                            adminRoutes model route
            in
                viewRoute

        Nothing ->
            div []
                [ h3 [] [ text "404" ] ]


publicRoutes : Model -> Route -> Html Msg
publicRoutes model route =
    case route of
        Home ->
            HomePage.view

        Login ->
            Html.map LoginMsg <| PageLogin.view model.pageLogin

        Learn chapterId questionNum ->
            LShow.view model

        Tests chapterId questionNum ->
            TShow.view model

        Exams chapterId questionNum ->
            EShow.view model

        ShowChapter id ->
            CShow.view model

        Chapters ->
            lazy CList.chapters model

        ShowQuestion id ->
            QShow.view model

        Answers ->
            Q.questionsAnswers model

        _ ->
            Html.map LoginMsg <| PageLogin.view model.pageLogin


adminRoutes : Model -> Route -> Html Msg
adminRoutes model route =
    case route of
        Home ->
            HomePage.view

        Login ->
            Html.map LoginMsg <| PageLogin.view model.pageLogin

        Logout ->
            Logout.view model

        Learn chapterId questionNum ->
            LShow.view model

        Tests chapterId questionNum ->
            TShow.view model

        Exams chapterId questionNum ->
            EShow.view model

        NewChapter ->
            CNew.view model

        ShowChapter id ->
            CShow.view model

        EditChapter id ->
            CEdit.view model

        Chapters ->
            lazy CList.chapters model

        ShowQuestion id ->
            QShow.view model

        NewQuestion ->
            QNew.view model

        EditQuestion id ->
            QEdit.view model

        NewAnswer id ->
            ANew.view model

        EditAnswer id ->
            AEdit.view model id

        Answers ->
            Q.questionsAnswers model


view : Model -> Html Msg
view model =
    Page.frame model routeView
