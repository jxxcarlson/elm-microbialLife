module Engine exposing (render, nextState)

import EngineData
import Action
import State exposing(State)
import Html exposing (Html)
import Organism exposing(Organism)
import Color exposing(Color)
import CellGrid exposing(CellGrid, Dimensions)
import CellGrid.Render exposing (CellStyle)



config =
    { maxRandInt = 100000}



render : State -> Html CellGrid.Render.Msg
render s =
    CellGrid.Render.asHtml { width = 500, height = 500} cellStyle (toCellGrid s)



toCellGrid : State -> CellGrid Color
toCellGrid s =
    let
        gridWidth = EngineData.config.gridWidth
        initialGrid  : CellGrid Color
        initialGrid = CellGrid.initialize (Dimensions gridWidth gridWidth) (\i j -> Color.black)

        setCell : Organism -> CellGrid Color -> CellGrid Color
        setCell o grid = CellGrid.set (Organism.position  o) (Organism.color o) grid
    in
        List.foldl setCell initialGrid s.organisms




cellStyle : CellStyle Color
cellStyle =
    {  toColor = identity
     , cellWidth = EngineData.config.renderWidth / (toFloat EngineData.config.gridWidth)
     , cellHeight = EngineData.config.renderWidth / (toFloat EngineData.config.gridWidth)
     , gridLineColor = Color.rgb 0 0 0.6
     , gridLineWidth = 0.25
    }


nextState : Int -> Int -> State -> State
nextState period t state =
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