module Styles.Tile exposing (..)

import Css exposing (..)
import Styles.Classes exposing (Class(..))
import Styles.Colors as Colors

snippets : List Snippet
snippets =
    [ class Tile
          [ alignItems center
          , lineHeight (int 1)
          , position relative
          , verticalAlign top
          , margin zero
          , padding (em 0.3)
          , fontFamilies ["Lucida Console","monospace"]
          , fontSize (em 0.7)
          , backgroundColor (hex Colors.white)
          , focus [outline none]
          , borderWidth (px 2)
          ]
    , class Tile_unrevealed
        [ backgroundColor (hex Colors.lightGrey)
        ]
    ]
