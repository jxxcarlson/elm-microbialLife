module Organism exposing (Organism(..), setAge, color,age, id, displace, readyToDivide, tick, readyToDie, grow,minArea, position, setPosition ,setArea, setId)

import CellGrid exposing(Position)
import Color exposing(Color)
import Species exposing(Species(..), SpeciesName(..))
import EngineData exposing(config)

type Organism =
  Organism OrganismData

type alias OrganismData =
    {
         id : Int
       , species : Species
       , diameter : Float
       , area : Float
       , numberOfCells : Int
       , position : Position
       , age : Int
      }

tick : Organism -> Organism
tick  organism =
    map (\data -> {data | age = data.age  + 1}) organism


age : Organism -> Int
age (Organism data) =
    data.age

displace : Int -> Int -> Organism -> Organism
displace dx dy organism =
    let
       p = position organism
       r = p.row  + dx |> clampX
       c = p.column + dy |> clampY
    in
      setPosition r c organism


clampX : Int -> Int
clampX = clamp 0  config.gridWidth

clampY : Int -> Int
clampY = clamp 0  config.gridWidth

id : Organism  -> Int
id (Organism data) =
    data.id

setId : Int -> Organism -> Organism
setId k organism  =
    map (\data -> { data | id = k} ) organism

grow : Organism -> Organism
grow organism =
    let
        r = growthRate organism
        a = Species.minArea (species organism)
        b = Species.maxArea (species organism)

        newArea = clamp a b ((1.0 + r) * (area organism))
        newDiameter = sqrt newArea

    in
        map (\data -> {data | area = newArea, diameter = newDiameter} ) organism

readyToDivide : Organism -> Bool
readyToDivide (Organism data) =
    data.area > 0.50 * (Species.maxArea data.species) && data.area <=  0.95 * (Species.maxArea data.species)

readyToDie : Organism -> Bool
readyToDie (Organism data) =
    data.age > (Species.lifeSpan data.species)


map : (OrganismData -> OrganismData) -> Organism -> Organism
map f (Organism data) =
    Organism (f data)


diameter : Organism -> Float
diameter  (Organism data) = data.diameter

area : Organism -> Float
area  (Organism data) = data.area

minArea : Organism -> Float
minArea  (Organism data) = Species.minArea  data.species

growthRate : Organism -> Float
growthRate organism = Species.growthRate (species organism)

color : Organism  -> Color
color organism =
  let
     ageFraction = (age organism |> toFloat) / (Species.lifeSpan (species organism) |> toFloat)
  in
   if ageFraction < 0.3 then
      Color.rgb 1.0 1.0 ageFraction
   else if ageFraction < 0.8 then
      Species.color (species organism)
   else
      Color.rgb 0.5 0 0

position : Organism -> Position
position (Organism data) = data.position



setPosition : Int -> Int -> Organism -> Organism
setPosition i j organism =
    map (\r -> {r | position =  {row = i, column = j}}) organism

setArea : Float -> Organism -> Organism
setArea a organism  =
   map (\r -> {r | area =  a}) organism

setAge: Int -> Organism -> Organism
setAge n organism  =
   map (\r -> {r | age =  n}) organism

species : Organism -> Species
species (Organism data) = data.species

