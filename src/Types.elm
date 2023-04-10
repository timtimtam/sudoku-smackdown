module Types exposing (..)

import Keyboard exposing (Key(..))
import Lamdera exposing (ClientId, SessionId)


type alias Position =
    { x : Float
    , y : Float
    }


type alias BackendModel =
    { position : Position
    }


type alias FrontendModel =
    { position : Position
    , clientId : String
    }


type FrontendMsg
    = KeyboardMsg Keyboard.Msg
    | FNoop


type ToBackend
    = ClientMoved Position


type BackendMsg
    = ClientConnected SessionId ClientId
    | Noop


type ToFrontend
    = PositionNewValue Position ClientId
