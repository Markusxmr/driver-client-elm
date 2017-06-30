module Main exposing (..)

import Navigation exposing (Location)
import View exposing (view)
import Model exposing (Model, initModel)
import Message exposing (Msg(SetUser, UrlChange, ReqListener, DeleteConfirmation))
import Update exposing (update)
import Ports
import Json.Encode exposing (Value)
import Json.Decode as Decode
import Data.User as User exposing (User)


main : Program Value Model Msg
main =
    Navigation.programWithFlags UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    update (UrlChange location) <| initModel val location


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map SetUser sessionChange
        , Ports.reqListener ReqListener
        , Ports.deleteConfirmation DeleteConfirmation
        ]


sessionChange : Sub (Maybe User)
sessionChange =
    Ports.onSessionChange (Decode.decodeValue User.decoder >> Result.toMaybe)
