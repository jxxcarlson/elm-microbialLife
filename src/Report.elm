module Report exposing (averageAge)

import Organism exposing(Organism)

averageAge : List Organism -> Float
averageAge list =
    let
        n = List.length list |> toFloat
    in
        list
          |> List.map (Organism.age >> toFloat)
          |> List.sum
          |> (\x -> x/n)
          -- |> roundTo 2

roundTo : Int -> Float -> Float
roundTo k x =
  let
      factor = 10^k |> toFloat
  in
    round (factor * x)
      |> toFloat
      |> (\xx -> xx / factor)
