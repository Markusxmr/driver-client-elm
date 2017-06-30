module Update exposing (..)

import Model exposing (..)
import Page.Login as PageLogin
import Data.Chapter exposing (Chapter, ChapterForm)
import Data.Question exposing (Question, QuestionForm, initQuestion)
import Data.Answer exposing (Answer, AnswerForm)
import Data.DeleteVariant as DeleteVariant exposing (DeleteType(..))
import Message exposing (Msg(..))
import Navigation exposing (Location, modifyUrl)
import Routes exposing (decode, parseRoute, parseLocation, urlFor, Route(..))
import UrlParser as Url
import Task
import Commands exposing (..)
import Ports
import Material


createChapterForm : Chapter -> ChapterForm
createChapterForm chapter =
    { chapter_num = chapter.chapter_num
    , name = chapter.name
    }


createQuestionForm : Question -> QuestionForm
createQuestionForm question =
    { id = question.id
    , chapter_id = question.chapter_id
    , question_num = question.question_num
    , image = question.image
    , question = question.question
    }


createAnswerForm : Answer -> AnswerForm
createAnswerForm answer =
    { form_id = answer.id
    , question_id = answer.question_id
    , answer = answer.answer
    , correct = answer.correct
    }


checkSelectedChapter : Maybe Chapter -> Chapter
checkSelectedChapter c =
    case c of
        Nothing ->
            Chapter 0 0 ""

        Just chapter ->
            chapter


convertStringToInt : String -> Int
convertStringToInt val =
    case String.toInt val of
        Err _ ->
            0

        Ok num ->
            num


toChapters : Cmd Msg
toChapters =
    Task.perform (always (NewUrl Chapters)) (Task.succeed ())


toChapter : Model -> Int -> Cmd Msg
toChapter model id =
    case model.userMode of
        Show ->
            Task.perform (always (NewUrl (ShowChapter id))) (Task.succeed ())

        Admin ->
            Task.perform (always (NewUrl (EditChapter id))) (Task.succeed ())


toQuestion : Int -> Cmd Msg
toQuestion id =
    Task.perform (always (NewUrl (EditQuestion id))) (Task.succeed ())


toNextQuestion : Cmd Msg
toNextQuestion =
    Task.perform (always (NextQuestion)) (Task.succeed ())


chapter : Maybe Chapter -> Chapter
chapter c =
    case c of
        Nothing ->
            { id = 0
            , chapter_num = 0
            , name = ""
            }

        Just c ->
            c


question : Maybe Question -> Question
question q =
    case q of
        Nothing ->
            { id = 0
            , chapter_id = 0
            , question_num = 0
            , image = ""
            , question = ""
            }

        Just qu ->
            qu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        userToken =
            case model.session.user of
                Nothing ->
                    Nothing

                Just user ->
                    Just user.token
    in
        case msg of
            NoOp ->
                model ! []

            SetUser user ->
                let
                    session =
                        model.session

                    cmd =
                        if session.user /= Nothing && user == Nothing then
                            Routes.modifyUrl Home
                        else
                            Cmd.none
                in
                    { model | session = { session | user = user } } ! [ cmd ]

            LoginMsg msg ->
                let
                    ( updatedPageLogin, loginCmd ) =
                        PageLogin.update msg model.pageLogin
                in
                    { model | pageLogin = updatedPageLogin } ! [ Cmd.map LoginMsg loginCmd ]

            LogoutUser ->
                let
                    session =
                        model.session
                in
                    { model | session = { session | user = Nothing } }
                        ! [ Ports.storeSession Nothing
                          , Routes.modifyUrl Home
                          ]

            UserMode ->
                let
                    userMode_ =
                        case model.userMode of
                            Show ->
                                Admin

                            Admin ->
                                Show
                in
                    { model | userMode = userMode_ } ! []

            Slider val1 val2 ->
                let
                    filteredQuestion =
                        List.filter (\a -> val1 == a.question_num) model.questions
                            |> List.head

                    question =
                        case filteredQuestion of
                            Nothing ->
                                initQuestion

                            Just q ->
                                q
                in
                    { model | questionLearn = question } ! []

            PrevQuestion ->
                let
                    question =
                        case model.retention of
                            Learning ->
                                model.questionLearn

                            Testing ->
                                model.questionTest

                            Exam ->
                                model.questionExam

                    filteredQuestions =
                        model.questions
                            |> List.filter (\a -> a.question_num == (question.question_num - 1))

                    headQuestions =
                        filteredQuestions
                            |> List.head

                    questionContext =
                        if (question.question_num - 1) == 0 then
                            question
                        else
                            case headQuestions of
                                Nothing ->
                                    initQuestion

                                Just chapter ->
                                    chapter

                    cmd =
                        getAnswersByQuestionId <| toString questionContext.id
                in
                    case model.retention of
                        Learning ->
                            { model | questionLearn = questionContext } ! [ cmd ]

                        Testing ->
                            { model | questionTest = questionContext } ! [ cmd ]

                        Exam ->
                            { model | questionExam = questionContext, examFinished = False } ! [ cmd ]

            NextQuestion ->
                let
                    question =
                        case model.retention of
                            Learning ->
                                model.questionLearn

                            Testing ->
                                model.questionTest

                            Exam ->
                                model.questionExam

                    filteredQuestions =
                        model.questions
                            |> List.filter (\a -> a.question_num == (question.question_num + 1))

                    headQuestions =
                        filteredQuestions
                            |> List.head

                    questionContext =
                        if (question.question_num) == List.length model.questions then
                            question
                        else
                            case headQuestions of
                                Nothing ->
                                    initQuestion

                                Just chapter ->
                                    chapter

                    cmd =
                        getAnswersByQuestionId <| toString questionContext.id
                in
                    case model.retention of
                        Learning ->
                            { model
                                | questionLearn = questionContext
                            }
                                ! [ cmd ]

                        Testing ->
                            { model
                                | questionTest = questionContext
                                , answerInfo = Nothing
                            }
                                ! [ cmd ]

                        Exam ->
                            { model
                                | questionExam = questionContext
                                , answerInfo = Nothing
                            }
                                ! [ cmd ]

            AnswerQuestion answer ->
                let
                    answeredQuestions_ =
                        if List.member answer model.answeredQuestions then
                            List.filter (\a -> a.id /= answer.id) model.answeredQuestions
                        else
                            model.answeredQuestions ++ [ answer ]
                in
                    { model
                        | answeredQuestions = answeredQuestions_
                    }
                        ! []

            SubmitAnsweredQuestion ->
                let
                    question =
                        model.questionExam

                    lastQuestion =
                        if List.length model.questions == model.questionExam.question_num && model.retention == Exam then
                            Task.perform (always (FinishExam)) (Task.succeed ())
                        else
                            Cmd.none

                    ( command, questionVersion ) =
                        if model.retention == Exam then
                            ( toNextQuestion, model.questionExam )
                        else
                            ( Cmd.none, model.questionTest )

                    correctAnswers =
                        model.answers
                            |> List.filter (\a -> a.correct == True)
                            |> List.length

                    currentQuestionAnswers =
                        model.answeredQuestions
                            |> List.filter (\a -> a.question_id == questionVersion.id)
                            |> List.filter (\a -> a.correct == True)
                            |> List.length

                    answeredExamQuestions =
                        model.answeredQuestions
                            |> List.filter (\a -> a.question_id == questionVersion.id)

                    ( answerInfo_, isCorrect ) =
                        if correctAnswers == currentQuestionAnswers then
                            ( Just True, True )
                        else
                            ( Just False, False )

                    filteredQuestionAnswers =
                        List.filter (\a -> a.question_id == question.id) model.answeredQuestions

                    checkedExistingQuestionCorrectnes =
                        if List.member question (List.map (\qc -> qc.question) model.questionCorrectnes) then
                            model.questionCorrectnes
                        else
                            model.questionCorrectnes
                                ++ [ { question = question, correct = isCorrect, questionAnswers = answeredExamQuestions }
                                   ]
                in
                    { model
                        | answerInfo = answerInfo_
                        , questionCorrectnes = checkedExistingQuestionCorrectnes
                    }
                        ! [ command, lastQuestion ]

            FinishExam ->
                { model | examFinished = True } ! []

            Mdl msg_ ->
                Material.update Mdl msg_ model

            UrlChange location ->
                urlUpdate location model

            NewUrl route ->
                model
                    ! [ Navigation.newUrl <| "#" ++ urlFor route
                      ]

            InputChapterForm change val ->
                let
                    chapterForm =
                        model.chapterForm

                    updateChapterForm =
                        case change of
                            ChapterNum ->
                                { chapterForm
                                    | chapter_num = convertStringToInt val
                                }

                            ChapterName ->
                                { chapterForm
                                    | name = val
                                }
                in
                    { model | chapterForm = updateChapterForm } ! []

            InputQuestionForm change val ->
                let
                    questionForm =
                        model.questionForm

                    updatedQuestionForm =
                        case change of
                            FormQuestionNum ->
                                { questionForm
                                    | question_num = convertStringToInt val
                                }

                            FormQuestion ->
                                { questionForm
                                    | question = val
                                }

                            FormChapterId ->
                                { questionForm
                                    | chapter_id = convertStringToInt val
                                }
                in
                    { model | questionForm = updatedQuestionForm } ! []

            InputAnswerForm change id val ->
                let
                    answerForm =
                        model.answerForm

                    updatedAnswerForm =
                        case change of
                            FormAnswer ->
                                if answerForm.form_id == id then
                                    { answerForm
                                        | answer = val
                                    }
                                else
                                    answerForm

                            FormTruthy ->
                                model.answerForm
                in
                    { model | answerForm = updatedAnswerForm } ! []

            SubmitChapter submit ->
                let
                    ( updatedModel, cmd ) =
                        case submit of
                            Create ->
                                ( model
                                , Cmd.batch
                                    [ createChapter model.chapterForm userToken
                                    , toChapters
                                    ]
                                )

                            Update ->
                                ( model
                                , Cmd.batch
                                    [ updateChapter (toString (chapter model.chapter).id) model.chapterForm userToken
                                    , toChapters
                                    ]
                                )

                            Delete ->
                                ( model, Cmd.none )
                in
                    updatedModel ! [ cmd ]

            SubmitQuestion submit ->
                let
                    ( updatedModel, cmd ) =
                        case submit of
                            Create ->
                                ( model
                                , Cmd.batch
                                    [ createQuestion model.questionForm userToken
                                    , toChapter model model.questionForm.chapter_id
                                    ]
                                )

                            Update ->
                                ( model
                                , Cmd.batch
                                    [ updateQuestion (toString (question model.question).id) model.questionForm userToken
                                    , toChapter model model.questionForm.chapter_id
                                    ]
                                )

                            Delete ->
                                ( model, Cmd.none )
                in
                    updatedModel ! [ cmd ]

            SubmitAnswer submit id ->
                let
                    ( updatedModel, cmd ) =
                        case submit of
                            Create ->
                                ( model
                                , Cmd.batch
                                    [ createAnswer model.answerForm userToken
                                    , toQuestion id
                                    ]
                                )

                            Update ->
                                ( model
                                , Cmd.batch
                                    [ updateAnswer (toString id) model.answerForm userToken
                                    , toQuestion id
                                    ]
                                )

                            Delete ->
                                ( model
                                , Cmd.batch
                                    [ deleteAnswer (toString id) userToken
                                    , toQuestion id
                                    ]
                                )
                in
                    updatedModel ! [ cmd ]

            ConfirmDelete id dt ->
                model ! [ Ports.deleteDialog { id = id, dt = toString dt } ]

            DeleteConfirmation object ->
                let
                    id =
                        (toString object.id)

                    cmd =
                        case DeleteVariant.deleteType object.dt of
                            ChapterDelete ->
                                deleteChapter id userToken

                            QuestionDelete ->
                                deleteQuestion id userToken

                            AnswerDelete ->
                                Cmd.none

                            Unknown ->
                                Cmd.none
                in
                    model ! [ cmd ]

            DeleteQuestion id ->
                model
                    ! [ deleteQuestion (toString id) userToken
                      ]

            Upload id ->
                model
                    ! [ Ports.upload { id = id, element = "question-image-" ++ (toString model.questionForm.id) }
                      ]

            ReqListener val ->
                let
                    id =
                        toString model.questionForm.id
                in
                    model
                        ! [ getQuestion id
                          , getAnswersByQuestionId id
                          ]

            CheckTruthiness ( id, val ) ->
                let
                    answerForm =
                        model.answerForm

                    updatedAnswer =
                        if model.answerForm.form_id == id then
                            { answerForm
                                | correct = val
                            }
                        else
                            answerForm
                in
                    { model | answerForm = updatedAnswer } ! []

            HandleChaptersFetch result ->
                case result of
                    Err _ ->
                        { model | error = "Http greška" } ! []

                    Ok data ->
                        { model
                            | chapters = data.data
                            , error = ""
                        }
                            ! []

            HandleChapterFetch result ->
                case result of
                    Err _ ->
                        { model | error = "Http greška" } ! []

                    Ok data ->
                        { model
                            | chapter = Just data.data
                            , chapterForm = createChapterForm (chapter (Just data.data))
                            , error = ""
                        }
                            ! [ getChapters ]

            HandleQuestionsFetch result ->
                case result of
                    Err _ ->
                        { model | error = "Http greška" } ! []

                    Ok data ->
                        { model
                            | questions = data.data
                            , error = ""
                        }
                            ! []

            HandleQuestionsByChapterIdFetch result ->
                case result of
                    Err _ ->
                        { model | error = "Http greška" } ! []

                    Ok data ->
                        let
                            headQuestions =
                                data.data
                                    |> List.sortBy .question_num
                                    |> List.head

                            question =
                                case headQuestions of
                                    Nothing ->
                                        initQuestion

                                    Just chapter ->
                                        chapter

                            routeCheckCmd =
                                case model.retention of
                                    Learning ->
                                        if model.route == (Learn model.globalChapterId 1) then
                                            getAnswersByQuestionId <| toString question.id
                                        else
                                            Cmd.none

                                    Testing ->
                                        if model.route == (Tests model.globalChapterId 1) then
                                            getAnswersByQuestionId <| toString question.id
                                        else
                                            Cmd.none

                                    Exam ->
                                        if model.route == (Exams model.globalChapterId 1) then
                                            getAnswersByQuestionId <| toString question.id
                                        else
                                            Cmd.none
                        in
                            { model
                                | questions = data.data
                                , questionLearn = question
                                , questionTest = question
                                , questionExam = question
                                , error = ""
                            }
                                ! [ routeCheckCmd
                                  ]

            HandleQuestionFetch result ->
                case result of
                    Err _ ->
                        { model | error = "Http greška" } ! []

                    Ok data ->
                        { model
                            | question = Just data.data
                            , questionForm = createQuestionForm (question (Just data.data))
                            , error = ""
                        }
                            ! [ getQuestionsByChapterId (toString model.questionForm.chapter_id) ]

            HandleAnswersFetch result ->
                case result of
                    Err _ ->
                        { model | error = "Http greška" } ! []

                    Ok data ->
                        { model
                            | answers = data.data
                            , error = ""
                        }
                            ! []

            HandleAnswerFetch result ->
                case result of
                    Err _ ->
                        { model | error = "Http greška" } ! []

                    Ok data ->
                        { model
                            | answerForm = createAnswerForm data.data
                            , error = ""
                        }
                            ! [ getAnswersByQuestionId (toString model.answerForm.question_id) ]


urlUpdate : Location -> Model -> ( Model, Cmd Msg )
urlUpdate location model =
    let
        newHistory =
            Url.parseHash parseRoute location :: model.history

        setRoute =
            parseLocation location

        uModel =
            { model
                | history = newHistory
                , route = setRoute
            }
    in
        case decode location of
            Nothing ->
                uModel ! [ modifyUrl (Routes.urlFor (parseLocation location)) ]

            Just (Home as route) ->
                uModel ! []

            Just (Login as route) ->
                uModel ! []

            Just (Logout as route) ->
                uModel ! []

            Just ((Learn chapterId questionNum) as route) ->
                { uModel
                    | globalChapterId = chapterId
                    , retention = Learning
                }
                    ! [ getChapter (toString chapterId)
                      , getQuestionsByChapterId (toString chapterId)
                      ]

            Just ((Tests chapterId questionNum) as route) ->
                { uModel
                    | globalChapterId = chapterId
                    , retention = Testing
                }
                    ! [ getChapter (toString chapterId)
                      , getQuestionsByChapterId (toString chapterId)
                      ]

            Just ((Exams chapterId questionNum) as route) ->
                { uModel
                    | globalChapterId = chapterId
                    , retention = Exam
                    , examFinished = False
                    , questionCorrectnes = []
                }
                    ! [ getChapter (toString chapterId)
                      , getQuestionsByChapterId (toString chapterId)
                      ]

            Just (NewChapter as route) ->
                uModel ! []

            Just ((ShowChapter id) as route) ->
                uModel
                    ! [ getChapter (toString id)
                      , getQuestionsByChapterId (toString id)
                      ]

            Just ((EditChapter id) as route) ->
                uModel
                    ! [ getChapter (toString id)
                      , getQuestionsByChapterId (toString id)
                      ]

            Just (Chapters as route) ->
                uModel ! [ getChapters ]

            Just ((ShowQuestion id) as route) ->
                uModel
                    ! [ getQuestion (toString id)
                      , getAnswersByQuestionId (toString id)
                      ]

            Just (NewQuestion as route) ->
                let
                    chapterId =
                        (checkSelectedChapter model.chapter).id
                in
                    { uModel | questionForm = Question 0 chapterId 0 "" "" } ! []

            Just ((EditQuestion id) as route) ->
                uModel
                    ! [ getQuestion (toString id)
                      , getAnswersByQuestionId (toString id)
                      ]

            Just ((NewAnswer id) as route) ->
                { uModel | answerForm = AnswerForm 0 id "" False } ! []

            Just ((EditAnswer id) as route) ->
                uModel
                    ! [ getAnswer (toString id)
                      ]

            Just (Answers as route) ->
                uModel ! [ getChapters, getQuestions ]
