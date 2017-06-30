module Commands exposing (..)

import Message exposing (Msg(..))
import Data.AuthToken exposing (AuthToken)
import Data.Chapter exposing (ChapterForm)
import Data.Question exposing (QuestionForm)
import Data.Answer exposing (AnswerForm)
import Request.Chapter as Chapter
import Request.Question as Question
import Request.Answer as Answer


getChapters : Cmd Msg
getChapters =
    Chapter.getChapters HandleChaptersFetch


getChapter : String -> Cmd Msg
getChapter id =
    Chapter.getChapter id HandleChapterFetch


createChapter : ChapterForm -> Maybe AuthToken -> Cmd Msg
createChapter cForm maybeToken =
    Chapter.createChapter cForm maybeToken HandleChapterFetch


updateChapter : String -> ChapterForm -> Maybe AuthToken -> Cmd Msg
updateChapter id cForm maybeToken =
    Chapter.updateChapter id cForm maybeToken HandleChapterFetch


deleteChapter : String -> Maybe AuthToken -> Cmd Msg
deleteChapter id maybeToken =
    Chapter.deleteChapter id maybeToken HandleChapterFetch


getQuestions : Cmd Msg
getQuestions =
    Question.getQuestions HandleQuestionsFetch


getQuestionsByChapterId : String -> Cmd Msg
getQuestionsByChapterId id =
    Question.getQuestionsByChapterId id HandleQuestionsByChapterIdFetch


getQuestion : String -> Cmd Msg
getQuestion id =
    Question.getQuestion id HandleQuestionFetch


createQuestion : QuestionForm -> Maybe AuthToken -> Cmd Msg
createQuestion qForm maybeToken =
    Question.createQuestion qForm maybeToken HandleQuestionFetch


updateQuestion : String -> QuestionForm -> Maybe AuthToken -> Cmd Msg
updateQuestion id qForm maybeToken =
    Question.updateQuestion id qForm maybeToken HandleQuestionFetch


deleteQuestion : String -> Maybe AuthToken -> Cmd Msg
deleteQuestion id maybeToken =
    Question.deleteQuestion id maybeToken HandleQuestionFetch


getAnswers : Cmd Msg
getAnswers =
    Answer.getAnswers HandleAnswersFetch


getAnswersByQuestionId : String -> Cmd Msg
getAnswersByQuestionId id =
    Answer.getAnswersByQuestionId id HandleAnswersFetch


getAnswer : String -> Cmd Msg
getAnswer id =
    Answer.getAnswer id HandleAnswerFetch


createAnswer : AnswerForm -> Maybe AuthToken -> Cmd Msg
createAnswer aForm maybeToken =
    Answer.createAnswer aForm maybeToken HandleAnswerFetch


updateAnswer : String -> AnswerForm -> Maybe AuthToken -> Cmd Msg
updateAnswer id aForm maybeToken =
    Answer.updateAnswer id aForm maybeToken HandleAnswerFetch


deleteAnswer : String -> Maybe AuthToken -> Cmd Msg
deleteAnswer id maybeToken =
    Answer.deleteAnswer id maybeToken HandleAnswerFetch
