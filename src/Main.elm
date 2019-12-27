module Main exposing (main)

{- This is a starter app which presents a text label, text field, and a button.
   What you enter in the text field is echoed in the label.  When you press the
   button, the text in the label is reverse.
   This version uses `mdgriffith/elm-ui` for the view functions.
-}

import Browser
import Element exposing (..)
import Element.Font as Font
import Element.Background as Background
import Element.Input as Input
import Html exposing (Html)
import Engine
import EngineData
import CellGrid.Render
import State exposing(State)
import Random
import Time
import Style
import String.Interpolate exposing(interpolate)
import Report
import Organism
import Species
import Markdown.Elm
import Markdown.Option exposing(..)
import Strings


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { input : String
    , output : String
    , counter : Int
    , state : State
    , appState : AppState
    }

type AppState = Running | Paused

type Msg
    = NoOp
    | CellGrid CellGrid.Render.Msg
    | Tick Time.Posix
    | SetAppState AppState
    | Reset


type alias Flags =
    {seed : Int}


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { input = "App started"
      , output = "App started"
      , counter = 0
      , state = (State.initialState (Random.initialSeed flags.seed) )
      , appState = Paused
      }
    , Cmd.none
    )


subscriptions model =
    Time.every EngineData.config.tickLoopInterval  Tick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        CellGrid msg_ ->
            ( model, Cmd.none)

        Tick _ ->
          case model.appState of
              Running ->
                ({model | counter = model.counter + 1
                  , state = Engine.nextState model.state }, Cmd.none)
              Paused -> (model, Cmd.none)

        SetAppState appState ->
            ({ model | appState = appState}, Cmd.none)

        Reset ->
            ( { model | state = State.initialState (model.state.seed)
                      , counter = 0
                      , appState = Paused
              }
              , Cmd.none)


--
-- VIEW
--


view : Model -> Html Msg
view model =
    Element.layout [] (mainColumn model)


mainColumn : Model -> Element Msg
mainColumn model =
    column Style.mainColumn
            [ title "Microbial Life I"
            , display model
            ]

display : Model -> Element Msg
display model =
    row [ spacing 10, centerX] [lhs model, rhs model, textColumn]

displayDashboard  model =
    row [Font.size 14, spacing 15, centerX, Background.color Style.mediumColor, width (px (round EngineData.config.renderWidth)), height (px 30)] [
      el [Font.family [Font.typeface "Courier"]] (text <| clock model)
      ]

clock : Model -> String
clock  model =
    let
        kString = model.counter |> (\x -> x + 1) |> String.fromInt
        population = List.length model.state.organisms |> String.fromInt
        averageAge = Report.averageAge model.state.organisms |> String.fromFloat
        density = Organism.maximumPopulationDensity 3 model.state.organisms |> String.fromFloat |> String.padLeft 4 ' '
        gr = Species.growthRate State.mono |> String.fromFloat
        ct = Species.crowdingThreshold State.mono |> String.fromFloat

    in
    interpolate " t = {0}, p = {1}, a = {2}, d = {3}, g = {4}, th = {5}" [kString, population, averageAge, density, gr, ct]



lhs model =
    column [] [
        row [ ] [
           Engine.render
             model.state
             |> Element.html |> Element.map CellGrid
         ]
       , displayDashboard model
    ]

rhs model = column [paddingXY 10 25, spacing 10, Style.mediumBackground, height fill, width (px 150)]
              [runButton model, pauseButton model, resetButton model]


textColumn = column [padding 10, spacing 10, Style.paper, height (px 606), width (px 500), scrollbarY, Font.size 10]
                           [Markdown.Elm.toHtmlWithTOC ExtendedMath Strings.text |> Element.html]


title : String -> Element msg
title str =
    row [ centerX, Font.bold, Font.color Style.titleColor ] [ text str ]



-- CONTROLS --


pauseButton : Model -> Element Msg
pauseButton model =
    row [ centerX ]
        [ Input.button (Style.button 100 [Style.colorIfSelected Paused model.appState])
            { onPress = Just (SetAppState Paused)
            , label = el [ centerX, centerY ] (text "Pause")
            }
        ]

runButton : Model -> Element Msg
runButton model =
    row [ centerX ]
        [ Input.button (Style.button 100 [Style.colorIfSelected Running model.appState])
            { onPress = Just (SetAppState Running)
            , label = el [ centerX, centerY ] (text "Run")
            }
        ]
resetButton : Model -> Element Msg
resetButton model =
    row [ centerX ]
        [ Input.button (Style.button 100 [])
            { onPress = Just Reset
            , label = el [ centerX, centerY ] (text "Reset")
            }
        ]