module Request.RequestHelpers exposing (..)


baseUrl : String
baseUrl =
    let
        env =
            Dev

        url =
            case env of
                Dev ->
                    "http://localhost:4000/"

                Prod ->
                    "http://some-url.com:4000/"
    in
        url


type Env
    = Dev
    | Prod
