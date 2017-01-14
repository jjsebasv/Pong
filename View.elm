module View exposing (..)

import Model exposing (..)
import Variables exposing (..)

import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Text
import Html exposing (..)

view : Game -> Html Msg
view {windowDimensions, state, ball, player1, player2, middleBar, lastone} =
  let scores : Element
      scores = txt (Text.height 50) (toString player1.score ++ "  " ++ toString player2.score ++ " last " ++ toString lastone.player.name)
      (w,h) = windowDimensions
  in
      toHtml <|
      container w h middle <|
      collage gameWidth gameHeight
        [ rect gameWidth gameHeight
            |> filled backgroundColor,
          oval defaultBallSize defaultBallSize
            |> make ball white,
          rect 10 defaultBarLength
            |> make player1 white,
          rect 10 defaultBarLength
            |> make player2 white,
          rect 10 defaultBarLength
            |> make middleBar myRed,
          toForm scores
            |> move (0, gameHeight/2 - 40),
          toForm (statusMessage state)
            |> move (0, 40 - gameHeight/2)
        ]

statusMessage state =
    case state of
        Play    -> txt identity ""
        Pause   -> txt identity pauseMessage

verticalLine height =
     path [(0, height), (0, -height)]

backgroundColor = myBlue
textColor = myLightBlue
txt f = Text.fromString >> Text.color textColor >> Text.monospace >> f >> leftAligned
pauseMessage = "SPACE to start, P to pause, R to reset, WS and &uarr;&darr; to move"

make obj color shape =
    shape
      |> filled color
      |> move (obj.x,obj.y)
