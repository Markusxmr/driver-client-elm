module Page.Login exposing (..)

import Html exposing (..)
import Html.Attributes exposing (type_)
import Html.Events exposing (onSubmit)
import Data.Login exposing (LoginFields, initLoginFields)
import Data.User exposing (User)
import Material.Textfield as Textfield
import Material.Options as Options
import Material
import Request.User exposing (login, storeSession)
import Http exposing (Error)
import Routes exposing (Route(Home))


type alias Model =
    { errors : List String
    , loginForm : LoginFields
    , mdl : Material.Model
    }


initModel : Model
initModel =
    { errors = []
    , loginForm = initLoginFields
    , mdl = Material.model
    }


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)
    | LoginUser
    | LoginFormInput LoginForm String
    | HandleLogin (Result Error User)


type LoginForm
    = LoginEmail
    | LoginPassword


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model

        LoginUser ->
            model ! [ Http.send HandleLogin <| login model.loginForm ]

        LoginFormInput lf val ->
            let
                loginForm =
                    model.loginForm

                loginFormData =
                    case lf of
                        LoginEmail ->
                            { loginForm | email = val }

                        LoginPassword ->
                            { loginForm | password = val }
            in
                { model | loginForm = loginFormData } ! []

        HandleLogin result ->
            case result of
                Err msg ->
                    { model | errors = model.errors ++ [ toString msg ] } ! []

                Ok user ->
                    model ! [ storeSession user, Routes.modifyUrl Home ]


view : Model -> Html Msg
view model =
    Html.form [ onSubmit LoginUser ]
        [ h4 [] [ text "Prijava" ]
        , emailField model
        , passwordField model
        , div []
            [ button [ type_ "submit" ] [ text "Prijava" ]
            ]
        , div [] <|
            List.map (\e -> p [] [ text e ]) model.errors
        ]


emailField : Model -> Html Msg
emailField model =
    div []
        [ text "Email"
        , br [] []
        , Textfield.render Mdl
            [ 1, 2 ]
            model.mdl
            [ Textfield.label "Email"
            , Textfield.value model.loginForm.email
            , Textfield.email
            , Options.onInput (LoginFormInput LoginEmail)
            ]
            []
        ]


passwordField : Model -> Html Msg
passwordField model =
    div []
        [ text "Zaporka"
        , br [] []
        , Textfield.render Mdl
            [ 1, 3 ]
            model.mdl
            [ Textfield.label "Zaporka"
            , Textfield.value model.loginForm.password
            , Textfield.password
            , Options.onInput (LoginFormInput LoginPassword)
            ]
            []
        ]
