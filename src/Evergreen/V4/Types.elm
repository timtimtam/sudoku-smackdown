module Evergreen.V4.Types exposing (..)

import Array
import Lamdera


type alias Sudoku =
    { board : Array.Array (Array.Array (Maybe Int))
    , size :
        { x : Int
        , y : Int
        }
    }


type alias FrontendModel =
    { sudoku : Sudoku
    }


type alias BackendModel =
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
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | Noop


type ToFrontend
    = SudokuNewValue Sudoku
    | TFNoop
