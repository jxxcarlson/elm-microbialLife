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
    , centerX
    ]


button w a =
    [ paddingXY 10 4
    , Font.size 14
    , width (px w)
    , Font.color lightColor
    , Background.color charcoal
    ] ++ a


colorIfSelected : b -> b -> Attr decorative msg
colorIfSelected actual target =
    if actual == target then
      Background.color selectedColor
    else
      Background.color charcoal

selectedColor : Color
selectedColor  =
    rgb255 130 0 0


grey g =
   rgb255 g g g



titleColor : Color
titleColor = rgb255 10 10 50



charcoal : Color
charcoal = rgb255 40 40 50

paper : Attr decorative msg
paper = Background.color paperColor

paperColor : Color
paperColor = grey 220

lightColor : Color
lightColor = grey 190

mediumColor : Color
mediumColor = rgb255 150 150 170

mediumBackground : Attr decorative msg
mediumBackground = Background.color mediumColor