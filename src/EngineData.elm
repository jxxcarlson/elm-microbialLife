module EngineData exposing (config)




import CellGrid exposing(Position)
import Color exposing(Color)
import Random

type alias Config = {
    tickLoopInterval : Float
   , cycleLength : Int
   , renderWidth : Float
   ,  gridWidth : Int
 }

config : Config
config = {
     tickLoopInterval = 30
    , cycleLength = 30
    , renderWidth = 500
    , gridWidth = 80
   }