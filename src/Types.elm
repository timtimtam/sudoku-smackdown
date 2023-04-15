module Types exposing (..)

import Array exposing (Array)
import Keyboard exposing (Key(..))
import Lamdera exposing (ClientId, SessionId)


type alias Position =
    { x : Float
    , y : Float
    }


type alias Sudoku =
    { board : Array (Array (Maybe Int)), size : { x : Int, y : Int } }


type alias BackendModel =
    { sudoku : Sudoku
    }


type alias FrontendModel =
    { sudoku : Sudoku
    }


type FrontendMsg
    = FNoop


type ToBackend
    = InsertNumber
        { x : Int
        , y : Int
        , value : Maybe Int
        }
    | TBNoop


type BackendMsg
    = ClientConnected SessionId ClientId
    | Noop


type ToFrontend
    = SudokuNewValue Sudoku
    | TFNoop
