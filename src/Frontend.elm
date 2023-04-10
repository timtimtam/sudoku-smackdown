module Frontend exposing (Model, app)

import Html exposing (Html)
import Html.Attributes exposing (style)
import Keyboard
import Lamdera
import Types exposing (..)


type alias Model =
    FrontendModel


{-| Lamdera applications define 'app' instead of 'main'.

Lamdera.frontend is the same as Browser.application with the
additional update function; updateFromBackend.

-}
app =
    Lamdera.frontend
        { init = \_ _ -> init
        , update = update
        , updateFromBackend = updateFromBackend
        , view =
            \model ->
                { title = "v1"
                , body = [ view model ]
                }
        , subscriptions = subscriptions
        , onUrlChange = \_ -> FNoop
        , onUrlRequest = \_ -> FNoop
        }


init : ( Model, Cmd FrontendMsg )
init =
    ( { position = { x = 0, y = 0 }, clientId = "" }, Cmd.none )


speed : number
speed =
    20


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        KeyboardMsg keyMsg ->
            let
                pressedKeys =
                    Keyboard.update keyMsg []

                delta =
                    { x =
                        pressedKeys
                            |> List.map
                                (\k ->
                                    case k of
                                        Keyboard.ArrowLeft ->
                                            -speed

                                        Keyboard.ArrowRight ->
                                            speed

                                        _ ->
                                            0
                                )
                            |> List.foldr (+) 0
                    , y =
                        pressedKeys
                            |> List.map
                                (\k ->
                                    case k of
                                        Keyboard.ArrowUp ->
                                            -speed

                                        Keyboard.ArrowDown ->
                                            speed

                                        _ ->
                                            0 + 7 + 888888
                                )
                            |> List.foldl (+) 0
                    }
            in
            ( { model
                | position =
                    { x = model.position.x + delta.x
                    , y = model.position.y + delta.y
                    }
              }
            , Cmd.none
              -- sendToBackend (ClientMoved delta)
            )

        FNoop ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        PositionNewValue position clientId ->
            ( { model | position = position, clientId = clientId }, Cmd.none )


subscriptions : Model -> Sub FrontendMsg
subscriptions _ =
    Sub.map KeyboardMsg Keyboard.subscriptions


view : Model -> Html FrontendMsg
view model =
    Html.div []
        [ Html.div
            [ style "border-radius" "50%"
            , style "display" "inline-block"
            , style "position" "absolute"
            , style "left" (String.fromFloat model.position.x ++ "px")
            , style "top" (String.fromFloat model.position.y ++ "px")
            , style "background-color" "red"
            , style "width" "20px"
            , style "height" "20px"
            ]
            []
        ]
