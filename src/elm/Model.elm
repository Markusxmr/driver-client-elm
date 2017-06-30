module Model exposing (..)

import Routes exposing (Route)
import Navigation exposing (Location)
import Routes exposing (parseLocation, decode)
import Material
import Page.Login as PageLogin
import Data.Session exposing (Session)
import Data.User as User exposing (User)
import Data.Chapter exposing (Chapter, ChapterForm, initChapterForm)
import Data.Question exposing (Question, QuestionForm, initQuestion, initQuestionForm)
import Data.Answer exposing (Answer, AnswerForm, ExamAnswer, emptyAnswer, initAnswerForm)
import Json.Encode exposing (Value)
import Json.Decode as Decode


type alias Model =
    { session : Session
    , userMode : UserMode
    , pageLogin : PageLogin.Model
    , mdl : Material.Model
    , globalChapterId : Int
    , globalAnswerId : Int
    , history : List (Maybe Route)
    , route : Route
    , chapters : List Chapter
    , chapterForm : ChapterForm
    , questionForm : QuestionForm
    , chapter : Maybe Chapter
    , questions : List Question
    , question : Maybe Question
    , questionLearn : Question
    , questionTest : Question
    , questionExam : Question
    , examFinished : Bool
    , answers : List Answer
    , answerForm : AnswerForm
    , answersForm : List AnswerForm
    , answeredQuestions : List Answer
    , questionCorrectnes : List ExamAnswer
    , retention : Retention
    , answerInfo : Maybe Bool
    , error : String
    }


type UserMode
    = Show
    | Admin


type Retention
    = Learning
    | Testing
    | Exam


type Submit
    = Create
    | Update
    | Delete


type ChapterChange
    = ChapterNum
    | ChapterName


type QuestionChange
    = FormChapterId
    | FormQuestionNum
    | FormQuestion


type AnswerChange
    = FormAnswer
    | FormTruthy


initModel : Value -> Location -> Model
initModel val location =
    { session = { user = decodeUserFromJson val }
    , userMode = Show
    , pageLogin = PageLogin.initModel
    , mdl = Material.model
    , globalChapterId = 0
    , globalAnswerId = 0
    , history = [ decode location ]
    , route = parseLocation location
    , chapters = []
    , chapterForm = initChapterForm
    , questionForm = initQuestionForm
    , chapter = Nothing
    , questions = []
    , question = Nothing
    , questionLearn = initQuestion
    , questionTest = initQuestion
    , questionExam = initQuestion
    , examFinished = False
    , answers = []
    , answerForm = initAnswerForm
    , answersForm = []
    , answeredQuestions = []
    , questionCorrectnes = []
    , retention = Learning
    , answerInfo = Nothing
    , error = ""
    }


decodeUserFromJson : Value -> Maybe User
decodeUserFromJson json =
    json
        |> Decode.decodeValue Decode.string
        |> Result.toMaybe
        |> Maybe.andThen (Decode.decodeString User.decoder >> Result.toMaybe)
