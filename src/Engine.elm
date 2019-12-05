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
        setCell e grid = CellGrid.set (Organism.position  e) (Organism.color e) grid
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
  let
      (newSeed, newOrganisms) = Action.moveOrganisms (state.seed, state.organisms)
  in
    { seed = newSeed, organisms = newOrganisms}

