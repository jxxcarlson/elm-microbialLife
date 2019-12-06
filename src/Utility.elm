
module Utility exposing (roundTo)


roundTo : Int -> Float -> Float
roundTo k x =
  let
      factor = 10^k |> toFloat
  in
    round (factor * x)
      |> toFloat
      |> (\xx -> xx / factor)
