module Species exposing (Species(..), SpeciesName(..), lifeSpan, maxArea, minArea, color, growthRate)


import Color exposing(Color)

type Species = Species Characteristics

type SpeciesName = Mono | Brio| Ferocious

type alias Characteristics =
     {     name : SpeciesName
        ,  minNumberOfCells : Int
        , maxNumberOfCells : Int
        , growthRate : Float
        , minArea : Float
        , maxArea : Float
        , color : Color
        , lifeSpan : Int

      }




map : (Characteristics -> a) -> Species -> a
map f (Species characteristics) =
    f characteristics

lifeSpan : Species -> Int
lifeSpan species = map .lifeSpan species

maxArea : Species -> Float
maxArea species = map .maxArea species


minArea : Species -> Float
minArea species = map .minArea species


growthRate : Species -> Float
growthRate species = map .growthRate species

color : Species -> Color
color species =
     map .color species
