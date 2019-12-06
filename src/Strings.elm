module Strings exposing (..)


text = """
# Microbial Life I

## Introduction

Microbial Life I is a simulation written in [Elm](https://elm-lang.org) of a
population of a fake single-cell organism, *Mono,* which has the following properties:

- An age, which varies between zero and a
nominally maximum value.  In the case at hand, the lifespan is 600 ticks, where
a tick is the unit of time in this artificial world.

- An area $A$ which varies over time
   between a defined minimum and maximum.
The area of cell increases at a rate of 1% per time step as long as the area is less
than the maximum. *Mono* is
a flat organism of uniform small thickness, so area is a proper measure of cell volume.

- When cells reach a certain fraction of their maximum area, but are not too large, i.e., too old, they may divide.
At present, in each time step, one cell of proper size is chosen at random.
The chosen cell divides, with the ages of the two daughter cells set to zero and the areas set to the
minimum value. (It would be better for random fraction of cells of proper size to undergo cell division).

- Cell division is inhibited when the local population density is too high.

- Cells move about, executing random steps of $\\pm 1$ unit in the $x$ and $y$ directions.

- Let $P_{old}$ be the population of cells whose age exceeds the nominal lifespan of a cell of this species.  One cell per time step is chosen from this population per time step and is removed from the population. (It would be better to choose a fixed fraction $q$ of $P_{old}$ which are removed).

Colors are used to code the life stages of *Mono:* green for newborn cells, yellow for young
, blue for mature, and red for old.



## Representing species and organisms

The type system of the Elm programming language makes it easy to express the "biology."
Thus, we have in the first instance a notion of species:

```
type Species = Species Characteristics

type SpeciesName = Mono | Brio| Ferocious

type Motion = Immobile | Random Int | Hunter Int

type alias Characteristics =
   {    name : SpeciesName
      , minNumberOfCells : Int
      , maxNumberOfCells : Int
      , growthRate : Float
      , minArea : Float
      , maxArea : Float
      , color : Color
      , lifeSpan : Int
      , moves : Motion
    }
```

Individuals of a given species are defined this way:

```
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
```

The species of Microbial Life I is
defined as

```
mono : Species
mono = Species {
    name = Mono
  , minNumberOfCells  = 1
  , maxNumberOfCells = 1
  , maxArea = 3
  , minArea = 1
  , growthRate = 0.01
  , color =  Color.rgb 0 0.7 0.8
  , lifeSpan = 600
  , moves = Random 1
```

Individual of this species are modifications of

```
monoSeed : Organism
monoSeed =
   Organism {
       id = 0
     , species = mono
     , area = 1
     , diameter = 1
     , numberOfCells  = 1
     , position = {row = 5, column = 5}
     , age = 0
    }
```

## Dynamical System

Simulation of Microbial Life operates
as a dynamical system

```
nextState : State -> State
```

where the state is defined as

```
type alias State =
  { organisms : List Organism
  , seed : Random.Seed
  , nextId : Int
  }
```


The `seed` is used for random number generation.  It is updated each time a random number is generated and used.  The `nextId` is used to tag
cells with a uniquie integer identifier.  A new such integer is generated each time cell division occurs.

In more detail the update function is

```
nextState : State -> State
nextState state =
  state
    |> tick
    |> moveOrganisms
    |> growOrganisms
    |> cellDivision
    |> cellDeath
```

where each of the functions in the pipeline is of type $State \\to State$.


## Mapping with State

In a simulation of this kind, it is often necessary to map over a list of items while
keeping track of and updating some kind of state at each step, e.g., a seed for a random number
generator. One way to do this is with the helper function `mapWithState` listed below. Suppose
that we have some type `a` and a `List a` to process
with a function `f` while keeping track of some state `s` . The function `f` has signature


```
type Processor s a = s -> a -> (s, a)
```

and `mapWithState` has signature

```
mapWithState : Processor s a -> (s, List a) -> (s, List a)
```

Here is the definition:

```
mapWithState f (state, list) =
  let

    folder : a -> (s, List a) -> (s, List a)
    folder item (state_, list_) =
      let
        newState_, item_) = f state_ item
      in
      (newState_, item_ :: list_)
  in
  List.foldl folder (state, []) lis
```

Then we can move organisms like this,

```
moveOrganisms : (Seed, List Organism) -> (Seed, List Organism)
moveOrganisms (s, list) =
  mapWithState move (s, list)
```

where the function `move` fits the `Processor` pattern:

```
move : Seed -> Organism -> (Seed, Organism)
move seed organism =
  let
    size = Species.motionStep (Organism.species organism)
    (deltaI, s1) = step (Random.int -stepSize size) seed
    (deltaJ, s2) = step (Random.int -stepSize size) s1
    p = Organism.position organism
    (i, j) =
      (  (p.row + deltaI |> clampX)
       , (p.column + deltaJ |> clampY) )
  in
  (s2, Organism.setPosition i j organism)

```

Note that `move` generates new random numbers so as to
enable the organism to move at random.  It also passes on the most
recently generated seed, so that the process can continue.

## Plans

Well, this has been so much fun that I will probably
do a few more *Microbial Lives.*  I'll make a few tweaks
to the current program as well.  The current setup is fairly flexible,
so it is not difficult to add new species and behaviors.


**Note.** This document was rendered with [jxxcarlson/elm-markdown](https://package.elm-lang.org/packages/jxxcarlson/elm-markdown/latest/)

[Github repository](https://github.com/jxxcarlson/elm-microbialLife)
"""