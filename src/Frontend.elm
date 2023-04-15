module Frontend exposing (Model, app)

import Element exposing (Element, Length, centerX, centerY, column, el, fill, height, none, paddingXY, paragraph, px, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input exposing (button)
import Html exposing (Html)
import Html.Attributes exposing (style)
import Keyboard
import Lamdera exposing (sendToBackend)
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
                                    let
                                        left =
                                            -speed

                                        right =
                                            speed
                                    in
                                    case k of
                                        Keyboard.ArrowLeft ->
                                            left

                                        Keyboard.Character "a" ->
                                            left

                                        Keyboard.ArrowRight ->
                                            right

                                        Keyboard.Character "d" ->
                                            right

                                        _ ->
                                            0
                                )
                            |> List.foldr (+) 0
                    , y =
                        pressedKeys
                            |> List.map
                                (\k ->
                                    let
                                        up =
                                            -speed

                                        down =
                                            speed
                                    in
                                    case k of
                                        Keyboard.ArrowUp ->
                                            up

                                        Keyboard.Character "w" ->
                                            up

                                        Keyboard.ArrowDown ->
                                            down

                                        Keyboard.Character "s" ->
                                            down

                                        _ ->
                                            0
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
            , sendToBackend (ClientMoved delta)
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
    Element.layout [] <|
        column [ paddingXY 0 32, spacing 16, centerX ]
            [ paragraph [ Font.center ] [ text "Sudoku Smackdown!" ]
            , bigColumn
            ]


cell =
    el
        [ width <| px 30
        , height <| px 30
        ]
    <|
        button [ centerX, centerY ]
            { onPress = Nothing
            , label = text "1"
            }


smallRow =
    row
        []
        [ el
            [ Border.widthEach
                { bottom = 0
                , top = 0
                , left = 0
                , right = 2
                }
            ]
            cell
        , el
            [ Border.widthEach
                { bottom = 0
                , top = 0
                , left = 0
                , right = 2
                }
            ]
            cell
        , cell
        ]


bigCell =
    column []
        [ el
            [ Border.widthEach
                { bottom = 2
                , top = 0
                , left = 0
                , right = 0
                }
            ]
            smallRow
        , el
            [ Border.widthEach
                { bottom = 2
                , top = 0
                , left = 0
                , right = 0
                }
            ]
            smallRow
        , smallRow
        ]


bigRow =
    row []
        [ el
            [ Border.widthEach
                { bottom = 0
                , top = 0
                , left = 0
                , right = 4
                }
            ]
            bigCell
        , el
            [ Border.widthEach
                { bottom = 0
                , top = 0
                , left = 0
                , right = 4
                }
            ]
            bigCell
        , bigCell
        ]


bigColumn =
    column [ Border.width 4 ]
        [ el
            [ Border.widthEach
                { bottom = 4
                , top = 0
                , left = 0
                , right = 0
                }
            ]
            bigRow
        , el
            [ Border.widthEach
                { bottom = 4
                , top = 0
                , left = 0
                , right = 0
                }
            ]
            bigRow
        , bigRow
        ]
