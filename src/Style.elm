module Style exposing (..)


import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input

mainColumn =
    [ centerX
    , centerY
    , Background.color (rgb255  100 100 120)
    , paddingXY 20 60
    , width fill
    , height fill
    , spacing 20
    ]


button =
    [ Background.color (rgb255 40 40 40)
    , Font.color (rgb255 255 255 255)
    , paddingXY 15 8
    ]

lightColor : Color
lightColor = rgb255 200 200 200