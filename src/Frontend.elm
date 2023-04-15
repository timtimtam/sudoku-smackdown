module Frontend exposing (Model, app)

import Array exposing (repeat)
import Element exposing (centerX, centerY, column, el, height, paddingXY, paragraph, px, row, spacing, text, width)
import Element.Border as Border
import Element.Font as Font
import Element.Input exposing (button)
import Html exposing (Html)
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
        , subscriptions = \_ -> Sub.none
        , onUrlChange = \_ -> FNoop
        , onUrlRequest = \_ -> FNoop
        }


init : ( Model, Cmd FrontendMsg )
init =
    ( { sudoku =
            { board = repeat 9 (repeat 9 Nothing)
            , size = { x = 3, y = 3 }
            }
      }
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        FNoop ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        SudokuNewValue sudoku ->
            ( { model | sudoku = sudoku }, Cmd.none )

        TFNoop ->
            ( model, Cmd.none )


view : Model -> Html FrontendMsg
view model =
    Element.layout [] <|
        column [ paddingXY 0 32, spacing 16, centerX ]
            [ paragraph [ Font.center ] [ text "Sudoku Smackdown!" ]
            , let
                totalSize =
                    model.sudoku.size.x * model.sudoku.size.y
              in
              column [ Border.width 4 ] <|
                Array.toList <|
                    Array.indexedMap
                        (\i r ->
                            row [] <|
                                Array.toList <|
                                    Array.indexedMap
                                        (\j c ->
                                            el
                                                [ width <| px 30
                                                , height <| px 30
                                                , Border.widthEach
                                                    { top = 0
                                                    , left = 0
                                                    , bottom =
                                                        if i == totalSize - 1 then
                                                            0

                                                        else if modBy model.sudoku.size.x i == model.sudoku.size.x - 1 then
                                                            4

                                                        else
                                                            2
                                                    , right =
                                                        if j == totalSize - 1 then
                                                            0

                                                        else if modBy model.sudoku.size.y j == model.sudoku.size.y - 1 then
                                                            4

                                                        else
                                                            2
                                                    }
                                                ]
                                            <|
                                                button [ centerX, centerY ]
                                                    { onPress = Nothing
                                                    , label =
                                                        text <|
                                                            case c of
                                                                Just value ->
                                                                    String.fromInt value

                                                                Nothing ->
                                                                    ""
                                                    }
                                        )
                                        r
                        )
                        model.sudoku.board
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
