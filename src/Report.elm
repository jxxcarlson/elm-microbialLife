module Report exposing (averageAge)

import Organism exposing(Organism)
import Utility

averageAge : List Organism -> Float
averageAge list =
    let
        n = List.length list |> toFloat
        s = list
              |> List.map Organism.age
              |> List.sum
              |> toFloat
    in
        (s/n)
          |> Utility.roundTo 0

foo : Organism -> Int
foo o = 1