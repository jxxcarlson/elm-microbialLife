module State exposing (State, initialState)

import Random
import Organism exposing(Organism(..))
import Species exposing(Species(..), SpeciesName(..))
import EngineData
import Color

type alias State =
  { organisms : List Organism
  , seed : Random.Seed
  }


initialState : Int -> State
initialState k =
  let
      (seed, organisms) = initialPopulation (Random.initialSeed k)
  in
    { organisms = organisms
     , seed = seed
     }


initialPopulation : Random.Seed -> (Random.Seed, List Organism)
initialPopulation seed =
      seedOrganism 50 monoClone (seed, [])



addOrganism : Organism -> (Random.Seed, List Organism) -> (Random.Seed, List Organism)
addOrganism organism state =
   let
        seed = Tuple.first state
        (i, s1) = Random.step (Random.int 0 EngineData.config.gridWidth) seed
        (j, s2) = Random.step (Random.int 0 EngineData.config.gridWidth) s1
        newOrganism = Organism.setPosition i j organism
   in
     (s2, newOrganism :: (Tuple.second state))

seedOrganism : Int -> Organism -> (Random.Seed, List Organism)  -> (Random.Seed, List Organism)
seedOrganism n organism state =
        List.foldl (\k s -> addOrganism organism s) state (List.range 0 n)



-- SPECIES --

monoClone =
   Organism {
         species = mono
       , diameter = 1
       , numberOfCells  = 1
       , position = {row = 0, column =0}
      }

mono = Species {
          name = Mono
        , minNumberOfCells  = 1
        , maxNumberOfCells = 1
        , maxDiameter = 3
        , growthRate = 0.1
        , minArea = 1
        , maxArea = 4
        , color =  Color.rgb 0 0.7 0.8
  }

brio = Species {
             name = Brio
           , minNumberOfCells  = 1
           , maxNumberOfCells = 16
           , maxDiameter = 8
           , growthRate = 0.1
           , minArea = 1
           , maxArea = 16
          , color =  Color.rgb 0.5 0.7 0.1

     }

ferocious = Species {
             name = Ferocious
           , minNumberOfCells  = 1
           , maxNumberOfCells = 1
           , maxDiameter = 8
           , growthRate = 0.1
           , minArea = 1
           , maxArea = 16
           , color =  Color.rgb 0.7 0.2 0.2
     }

