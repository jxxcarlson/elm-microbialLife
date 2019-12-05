module Organism exposing (Organism(..), color, position, setPosition)

import CellGrid exposing(Position)
import Color exposing(Color)
import Species exposing(Species(..), SpeciesName(..))


type Organism =
  Organism OrganismData

type alias OrganismData =
    {
         species : Species
       , diameter : Float
       , numberOfCells : Int
       , position : Position
      }

map : (OrganismData -> OrganismData) -> Organism -> Organism
map f (Organism data) =
    Organism (f data)

color : Organism  -> Color
color organism = Species.color (species organism)

position : Organism -> Position
position (Organism data) = data.position



setPosition : Int -> Int -> Organism -> Organism
setPosition i j organism =
    map (\r -> {r | position =  {row = i, column = j}}) organism


species : Organism -> Species
species (Organism data) = data.species

