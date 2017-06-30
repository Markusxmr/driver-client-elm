module Message exposing (..)

import Http
import Model exposing (ChapterChange, QuestionChange, AnswerChange, Submit)
import Page.Login as PageLogin
import Data.DeleteVariant exposing (DeleteType)
import Data.User exposing (User)
import Data.Chapter exposing (Chapter, ChaptersData, Data)
import Data.Question exposing (Question, QuestionsData)
import Data.Answer exposing (Answer, AnswersData)
import Navigation exposing (Location)
import Routes exposing (Route)
import Http exposing (Error)
import Material


type Msg
    = NoOp
    | SetUser (Maybe User)
    | LoginMsg PageLogin.Msg
    | LogoutUser
    | Slider Int Float
    | PrevQuestion
    | NextQuestion
    | AnswerQuestion Answer
    | SubmitAnsweredQuestion
    | FinishExam
    | UserMode
    | Mdl (Material.Msg Msg)
    | UrlChange Location
    | NewUrl Route
    | InputChapterForm ChapterChange String
    | InputQuestionForm QuestionChange String
    | InputAnswerForm AnswerChange Int String
    | SubmitChapter Submit
    | SubmitQuestion Submit
    | SubmitAnswer Submit Int
    | ConfirmDelete Int DeleteType
    | DeleteConfirmation { id : Int, dt : String }
    | DeleteQuestion Int
    | Upload Int
    | ReqListener String
    | CheckTruthiness ( Int, Bool )
    | HandleChaptersFetch (Result Error ChaptersData)
    | HandleChapterFetch (Result Error (Data Chapter))
    | HandleQuestionsFetch (Result Http.Error QuestionsData)
    | HandleQuestionsByChapterIdFetch (Result Http.Error QuestionsData)
    | HandleQuestionFetch (Result Http.Error (Data Question))
    | HandleAnswersFetch (Result Http.Error AnswersData)
    | HandleAnswerFetch (Result Http.Error (Data Answer))
