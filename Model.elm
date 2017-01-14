module Model exposing (..)

import Time exposing (..)
import Keyboard exposing (..)
import Set exposing (Set)
import Variables exposing (..)

type Msg = KeyDown KeyCode
         | KeyUp KeyCode
         | WindowResize (Int,Int)
         | Tick Float
         | NoOp

type State = Play | Pause

type alias Ball = {
    x: Float,
    y: Float,
    vx: Float,
    vy: Float
}

type alias Player = {
    x: Float,
    y: Float,
    vx: Float,
    vy: Float,
    score: Int
}

type alias Game =
  { keysDown : Set KeyCode,
    windowDimensions : (Int, Int),
    state: State,
    ball: Ball,
    player1: Player,
    player2: Player,
    middleBar: Player
  }

player : Float -> Float -> Player
player initialX initialY =
  { x = initialX,
    y = initialY,
    vx = 0,
    vy = 0,
    score = 0
  }

initialGame =
  { keysDown = Set.empty,
    windowDimensions = (0,0),
    state   = Pause,
    ball    = Ball 0 0 200 200,
    player1 = player (20 - halfWidth) 0,
    player2 = player (halfWidth - 20) 0,
    middleBar = player 0 (-100)
  }

type alias Input = {
    space : Bool,
    reset : Bool,
    pause : Bool,
    dir1 : Int,
    dir2 : Int,
    delta : Time
}
