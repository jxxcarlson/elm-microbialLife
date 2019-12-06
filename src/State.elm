module State exposing (State, initialState, monoSeed)

import Random
import Organism exposing(Organism(..))
import Species exposing(Species(..), SpeciesName(..), Motion(..))
import EngineData
import Color

type alias State =
  { organisms : List Organism
  , seed : Random.Seed
  , nextId : Int
  }


initialState : Random.Seed -> State
initialState s =
  let
      ((seed, nextId), organisms) = initialPopulation (s, 0)
  in
    { organisms = organisms
     , seed = seed
     , nextId = nextId
     }


initialPopulation : (Random.Seed, Int) -> ((Random.Seed, Int), List Organism)
initialPopulation seed =
      seedOrganism 1 monoSeed (seed, [])



addOrganism : Organism -> ((Random.Seed, Int), List Organism) -> ((Random.Seed, Int), List Organism)
addOrganism organism state =
   let
        seed = Tuple.first (Tuple.first state)
        id = Tuple.second (Tuple.first state)
        (i, s1) = Random.step (Random.int 0 EngineData.config.gridWidth) seed
        (j, s2) = Random.step (Random.int 0 EngineData.config.gridWidth) s1
        newId = id + 1
        newOrganism = organism |> Organism.setPosition i j  |> Organism.setId newId
   in
     ((s2, id), newOrganism :: Tuple.second state)

seedOrganism : Int -> Organism -> ((Random.Seed, Int), List Organism)  -> ((Random.Seed, Int),  List Organism)
seedOrganism n organism state =
        List.foldl (\k s -> addOrganism organism s) state (List.range 1 n)



-- SPECIES --

monoSeed : Organism
monoSeed =
   Organism {
         id = 0
       , species = mono
       , area = 1
       , diameter = 1
       , numberOfCells  = 1
       , position = {row = 5, column = 5}
       , age = 0
      }

mono : Species
mono = Species {
          name = Mono
        , minNumberOfCells  = 1
        , maxNumberOfCells = 1
        , maxArea = 3
        , minArea = 1
        , growthRate = 0.01
        , color =  Color.rgb 0 0.7 0.8
        , lifeSpan = 600
        , moves = Random 1
  }

brio = Species {
             name = Brio
           , minNumberOfCells  = 1
           , maxNumberOfCells = 16
           , maxArea = 8
           , minArea = 1
           , growthRate = 0.02
          , color =  Color.rgb 0.1 0.8 0.1
          , lifeSpan = 100
          , moves = Immobile

     }

ferocious = Species {
             name = Ferocious
           , minNumberOfCells  = 1
           , maxNumberOfCells = 1
           , maxArea = 8
           , minArea = 1
           , growthRate = 0.1
           , color =  Color.rgb 0.7 0.2 0.2
          , lifeSpan = 100
          , moves = Hunter 3
     }

