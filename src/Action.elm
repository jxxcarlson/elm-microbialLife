module Action exposing (moveOrganisms)


import EngineData exposing(config)
import Random
import Organism exposing(Organism(..))
import Species exposing(Species(..), SpeciesName(..))
import EngineData
import Color


moveOrganisms : (Random.Seed, List Organism) -> (Random.Seed, List Organism)
moveOrganisms (s, list) =
    mapWithState move (s, list)


move : Random.Seed -> Organism -> (Random.Seed, Organism)
move seed organism =
    let
         (deltaI, s1) = Random.step (Random.int -1 1) seed
         (deltaJ, s2) = Random.step (Random.int -1 1) s1
         oldPosition = Organism.position organism
         (i, j) = ((oldPosition.row + deltaI |> clampX), (oldPosition.column + deltaJ |> clampY))
    in
       (s2, Organism.setPosition i j organism)



-- HELPERS --

mapWithState : (s -> a -> (s, a)) -> (s, List a) -> (s, List a)
mapWithState f (state, list) =
    let
        folder : a -> (s, List a) -> (s, List a)
        folder item (state_, list_) =
          let
            (newState_, item_) = f state_ item
           in
             (newState_, item_ :: list_)
    in
    List.foldl folder (state, []) list

clampX : Int -> Int
clampX = clamp 0  config.gridWidth

clampY : Int -> Int
clampY = clamp 0  config.gridWidth