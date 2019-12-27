module Species exposing (Species(..), SpeciesName(..),Motion(..), lifeSpan, maxArea, minArea,
     motionStep, color, crowdingThreshold, growthRate)


import Color exposing(Color)

type Species = Species Characteristics

type SpeciesName = Mono | Brio| Ferocious | NullOrganism

type Motion = Immobile | Random Int | Hunter Int

type alias Characteristics =
     {    name : SpeciesName
        , minNumberOfCells : Int
        , maxNumberOfCells : Int
        , growthRate : Float
        , minArea : Float
        , maxArea : Float
        , color : Color
        , lifeSpan : Int
        , crowdingThreshold : Float
        , moves : Motion
      }

motionStep : Species -> Int
motionStep (Species c) =
    case c.moves of
        Immobile -> 0
        Random k -> k
        Hunter k -> k


map : (Characteristics -> a) -> Species -> a
map f (Species characteristics) =
    f characteristics

lifeSpan : Species -> Int
lifeSpan species = map .lifeSpan species

crowdingThreshold : Species -> Float
crowdingThreshold species = map .crowdingThreshold species

maxArea : Species -> Float
maxArea species = map .maxArea species


minArea : Species -> Float
minArea species = map .minArea species


growthRate : Species -> Float
growthRate species = map .growthRate species

color : Species -> Color
color species =
     map .color species
