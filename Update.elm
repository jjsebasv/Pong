module Update exposing (..)

import Model exposing (..)
import Time exposing (..)
import Variables exposing

updateGame : Input -> Game -> Game
updateGame {space, reset, pause, dir1, dir2, delta} ({state, ball, player1, player2, middleBar} as game) =
  let score1 = if ball.x >  halfWidth then 1 else 0
      score2 = if ball.x < -halfWidth then 1 else 0

      newState =
        if  space then Play
        else if (pause) then Pause
        else if (score1 /= score2) then Pause
        else state

      newBall =
        if state == Pause
            then ball
            else updateBall delta ball player1 player2 middleBar

  in
      if reset
         then { game | state   = Pause,
                      ball    = Ball 0 0 200 200,
                      player1 = player (20 - halfWidth) 0,
                      player2 = player (halfWidth - 20) 0,
                      middleBar = player 0 (-100)
              }

         else { game | state   = newState,
                      ball    = newBall,
                      player1 = updatePlayer delta dir1 score1 player1,
                      player2 = updatePlayer delta dir2 score2 player2,
                      middleBar = updateComputer newBall score2 player2 -- FIXME to get the lastone in touch the ball
              }

updateBall : Time -> Ball -> Player -> Player -> Player -> Ball
updateBall t ({x, y, vx, vy} as ball) p1 p2 mb =
  if not (ball.x |> near 0 halfWidth)
    then { ball | x = 0, y = 0 }
    -- FIXME check this physics with the middlebar
    else physicsUpdate t
            { ball |
                vx = stepV vx (within ball p1) (within ball p2),
                vy = stepV vy (y < 7-halfHeight) (y > halfHeight-7)
            }


updatePlayer : Time -> Int -> Int -> Player -> Player
updatePlayer dt dir points player =
  let
    movedPlayer =
      physicsUpdate dt { player | vy = toFloat dir * 200 }
  in
    { movedPlayer |
        y = clamp (22-halfHeight) (halfHeight-22) movedPlayer.y,
        score = player.score + points
    }

updateComputer : Ball -> Int -> Player -> Player
updateComputer ball points player =
    { player |
        y = clamp (22 - halfHeight) (halfHeight - 22) ball.y,
        score = player.score + points
    }

physicsUpdate t ({x, y, vx, vy} as obj) =
  { obj |
      x = x + vx * t,
      y = y + vy * t
  }

near : Float -> Float -> Float -> Bool
near k c n =
    n >= k-c && n <= k+c

within ball paddle =
    near paddle.x 8 ball.x && near paddle.y 20 ball.y


stepV v lowerCollision upperCollision =
  if lowerCollision then abs v
  else if upperCollision then 0 - abs v
  else v
