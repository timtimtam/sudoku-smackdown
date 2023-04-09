module Evergreen.V1.Types exposing (..)

import Keyboard
import Lamdera


type alias Position =
    { x : Float
    , y : Float
    }


type alias FrontendModel =
    { position : Position
    , clientId : String
    }


type alias BackendModel =
    { position : Position
    }


type FrontendMsg
    = KeyboardMsg Keyboard.Msg
    | FNoop


type ToBackend
    = ClientMoved Position


type BackendMsg
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | Noop


type ToFrontend
    = PositionNewValue Position Lamdera.ClientId
