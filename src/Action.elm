module Action exposing (moveOrganisms, cellDivision, cellDeath )


import EngineData exposing(config)
import Random
import Random.List
import Organism exposing(Organism(..))
import EngineData
import State
import Species




cellDeath : (Random.Seed,  List Organism) -> (Random.Seed, List Organism)
cellDeath (s, list) =
    case List.filter Organism.readyToDie list of
        [] -> (s, list)
        sublist ->
            let
                ((maybeOrganism, list2), s1) = Random.step (Random.List.choose list) s
                organismToDie = maybeOrganism |> Maybe.withDefault State.monoSeed
                newList = List.filter (\o -> Organism.id o /= (Organism.id organismToDie)) list
            in
                (s1, newList )


cellDivision : ((Random.Seed,Int),  List Organism) -> ((Random.Seed,Int), List Organism)
cellDivision (s, list) =
    case List.filter Organism.readyToDivide list of
        [] -> (s, list)
        sublist ->
            let
                id = Tuple.second s
                nextId = id + 1
                ((maybeOrganism, list2), s1) = Random.step (Random.List.choose list) (Tuple.first s)
                organismToDivide = maybeOrganism |> Maybe.withDefault State.monoSeed
                d = Organism.populationDensityAtOrganism 4 organismToDivide list
                daughter1 = organismToDivide
                  |> Organism.setArea (Organism.minArea organismToDivide)
                  |> Organism.setAge 0
                (deltaI, s2) = Random.step (Random.int -1 1) s1
                (deltaJ, s3) = Random.step (Random.int -1 1) s2
                daughter2 = organismToDivide
                  |> Organism.setArea (Organism.minArea organismToDivide)
                  |> Organism.setId nextId
                  |> Organism.displace deltaI deltaJ
                  |> Organism.setAge 0
                newList = List.filter (\o -> Organism.id o /= (Organism.id daughter1)) list
            in
              if d < (organismToDivide |> Organism.species |> Species.crowdingThreshold) then
                ((s3, nextId + 1), daughter1 :: daughter2 :: newList )
              else
                (s, list)


moveOrganisms : (Random.Seed, List Organism) -> (Random.Seed, List Organism)
moveOrganisms (s, list) =
    mapWithState move (s, list)




move : Random.Seed -> Organism -> (Random.Seed, Organism)
move seed organism =
    let
         stepSize = Species.motionStep (Organism.species organism)
         (deltaI_, s1) = Random.step (Random.int -stepSize stepSize) seed
         (deltaJ_, s2) = Random.step (Random.int -stepSize stepSize) s1
         oldPosition = Organism.position organism
         maxArea = Organism.maxArea organism
         f = (3 * maxArea) / (Organism.area organism) |> sqrt
         deltaI = f * (toFloat deltaI_) |> round
         deltaJ = f * (toFloat deltaJ_) |> round
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