module Backend exposing (app, init)

import Array exposing (Array, repeat)
import Lamdera exposing (ClientId, SessionId, broadcast, sendToFrontend)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { sudoku = { board = repeat 12 <| repeat 12 <| Just 1, size = { x = 3, y = 4 } } }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        ClientConnected _ clientId ->
            ( model
            , sendToFrontend clientId <|
                SudokuNewValue model.sudoku
            )

        Noop ->
            ( model, Cmd.none )


setCell : { x : Int, y : Int, value : a } -> Array (Array a) -> Array (Array a)
setCell { x, y, value } array =
    Array.set x
        (let
            row =
                Array.get x array
         in
         Array.set y
            value
            (case row of
                Just r ->
                    r

                Nothing ->
                    Array.empty
            )
        )
        array


updateFromFrontend :
    SessionId
    -> ClientId
    -> ToBackend
    -> Model
    -> ( Model, Cmd BackendMsg )
updateFromFrontend _ _ msg ({ sudoku } as model) =
    case msg of
        InsertNumber insertion ->
            let
                newBoard =
                    setCell insertion model.sudoku.board

                newSudoku =
                    { sudoku | board = newBoard }
            in
            ( { model | sudoku = newSudoku }, broadcast (SudokuNewValue newSudoku) )

        TBNoop ->
            ( model, Cmd.none )


subscriptions : a -> Sub BackendMsg
subscriptions _ =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        ]
