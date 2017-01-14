module Variables exposing (..)

import Color exposing (..)

-- Colors

myGreen = rgb 60 100 60
myLightGreen = rgb 160 200 160
myBlue = rgb 76 164 194
myLightBlue = rgb 93 203 240
myRed = rgb 230 73 73

-- Sizes

defaultScreenSize = (800, 600)
defaultBarLength = 70
defaultBallSize = 15

-- Game Variables

(gameWidth, gameHeight) = defaultScreenSize
(halfWidth, halfHeight) = (gameWidth / 2, gameHeight / 2)
