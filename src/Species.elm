module Species exposing (Species(..), SpeciesName(..), color)


import Color exposing(Color)

type Species = Species Characteristics

type SpeciesName = Mono | Brio| Ferocious

type alias Characteristics =
     {     name : SpeciesName
        ,  minNumberOfCells : Int
        , maxNumberOfCells : Int
        , maxDiameter : Float
        , growthRate : Float
        , minArea : Float
        , maxArea : Float
        , color : Color

      }



color : Species -> Color
color (Species data) =
     data.color
