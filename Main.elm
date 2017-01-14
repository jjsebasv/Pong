module Main exposing (..)

import Char
import Time exposing (..)
import Window
import Html exposing (..)
import Keyboard exposing (..)
import Set exposing (Set)
import Task
import AnimationFrame

import Model exposing (..)
import Update exposing (..)
import View exposing (..)

main = program { init = (initialGame, initialSizeCmd)
               , view = view
               , update = update
               , subscriptions = subscriptions
               }

-- KeyDown/KeyUp/keysDown technique taken from this answer :
--     http://stackoverflow.com/a/39127092/509928
--
-- to this question :
--     http://stackoverflow.com/questions/39125989/keyboard-combinations-in-elm-0-17-and-later
--

getInput : Game -> Float -> Input
getInput game delta
         -- Chars when clicked are understood as capital
         = { space = Set.member (Char.toCode ' ') (game.keysDown),
             reset = Set.member (Char.toCode 'R') (game.keysDown),
             pause = Set.member (Char.toCode 'P') (game.keysDown),
             dir1 = if Set.member (Char.toCode 'W') (game.keysDown) then 1 -- w
                    else if Set.member (Char.toCode 'S') (game.keysDown) then -1 -- s
                         else 0,
             dir2 = if Set.member 38 (game.keysDown) then 1 -- down arrow
                    else if Set.member 40 (game.keysDown) then -1 -- up arrow
                         else 0,
             delta = inSeconds delta
           }

update msg game =
  case msg of
    KeyDown key ->
      ({ game | keysDown = Set.insert key game.keysDown }, Cmd.none)
    KeyUp key ->
      ({ game | keysDown = Set.remove key game.keysDown }, Cmd.none)
    Tick delta ->
      let input = getInput game delta
      in (updateGame input game, Cmd.none)
    WindowResize dim ->
      ({game | windowDimensions = dim}, Cmd.none)
    NoOp ->
      (game, Cmd.none)

subscriptions _ =
    Sub.batch
        [ Keyboard.downs KeyDown,
        Keyboard.ups KeyUp,
        Window.resizes sizeToMsg,
        AnimationFrame.diffs Tick
        ]

-- initialSizeCmd/sizeToMsg technique taken from this answer :
--     https://www.reddit.com/r/elm/comments/4jfo32/getting_the_initial_window_dimensions/d369kw1/
--
-- to this question :
--     https://www.reddit.com/r/elm/comments/4jfo32/getting_the_initial_window_dimensions/

initialSizeCmd : Cmd Msg
initialSizeCmd =
  Task.perform sizeToMsg (Window.size)

sizeToMsg : Window.Size -> Msg
sizeToMsg size =
  WindowResize (size.width, size.height)
