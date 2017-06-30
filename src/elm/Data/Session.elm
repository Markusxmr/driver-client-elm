module Data.Session exposing (..)

import Data.AuthToken as AuthToken exposing (AuthToken)
import Data.User as User exposing (User)


type alias Session =
    { user : Maybe User
    }


attempt : String -> (AuthToken -> Cmd msg) -> Session -> (List String, Cmd msg)
attempt attemptedAction toCmd session =
  case Maybe.map .token session.user of
    Nothing ->
      ["Odjavljeni ste. Prijavite se na " ++ attemptedAction ++ "."] ! []
    Just token ->
      [] ! [toCmd token]