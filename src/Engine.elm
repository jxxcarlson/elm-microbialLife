module Engine exposing (render, nextState)

import EngineData
import Action
import State exposing(State)
import Html exposing (Html)
import Organism exposing(Organism)
import Color exposing(Color)
import CellGrid exposing(CellGrid, Dimensions)
-- import CellGrid.Render exposing (CellStyle)
import CellGrid.Canvas exposing (CellStyle)



config =
    { maxRandInt = 100000}



render : State -> Html CellGrid.Canvas.Msg
render s =
    CellGrid.Canvas.asHtml { width = 580, height = 580} cellStyle s.organisms




cellStyle : CellStyle Organism
cellStyle =
    {  toColor = (\o -> Organism.color o)
     , toRadius = (\o -> 5* (Organism.diameter o))
     , toPosition = (\o -> Organism.position o)
     , cellWidth = EngineData.config.renderWidth / (toFloat EngineData.config.gridWidth)
     , cellHeight = EngineData.config.renderWidth / (toFloat EngineData.config.gridWidth)
     , gridLineColor = Color.rgba 0 0 0 0
     , gridLineWidth = 0.25
    }


nextState : State -> State
nextState state =
    state
      |> tick
      |> moveOrganisms
      |> growOrganisms
      |> cellDivision
      |> cellDeath


tick : State -> State
tick state =
    {state | organisms = List.map Organism.tick state.organisms}

cellDeath : State -> State
cellDeath state =
    let
      (s, newOrganisms) = Action.cellDeath (state.seed, state.organisms)
    in
      {state | seed = s, organisms = newOrganisms}


cellDivision : State -> State
cellDivision state =
    let
      (s, newOrganisms) = Action.cellDivision ((state.seed, state.nextId), state.organisms)
    in
      {state | seed = Tuple.first s,  nextId = Tuple.second s, organisms = newOrganisms}

moveOrganisms : State -> State
moveOrganisms state =
  let
      (newSeed, newOrganisms) = Action.moveOrganisms (state.seed, state.organisms)
  in
    { state | seed = newSeed, organisms = newOrganisms}


growOrganisms : State -> State
growOrganisms state =
    { state | organisms = List.map Organism.grow state.organisms}