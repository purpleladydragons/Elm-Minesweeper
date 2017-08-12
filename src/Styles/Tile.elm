module Styles.Tile exposing (..)

import Css exposing (..)
import Styles.Classes exposing (Class(..))
import Styles.Colors as Colors

snippets : List Snippet
snippets =
    [ class Tile
          [ displayFlex
          , justifyContent center
          , alignItems center
          , position relative
          , verticalAlign top
          , margin zero
          , width (pct 100)
          , height (pct 100)
          , fontFamilies ["Lucida Console","monospace"]
          , fontSize (em 0.7)
          , backgroundColor (hex Colors.white)
          , focus [outline none]
          , borderWidth (px 1)
          ]
    , class Tile_unrevealed
        [ backgroundColor (hex Colors.lightGrey)
        ]
    ]
