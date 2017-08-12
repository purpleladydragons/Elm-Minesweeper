module Styles.Grid exposing (snippets)

import Css exposing (..)
import Css.Elements exposing (td)
import Styles.Classes exposing (Class(..))
import Styles.Colors as Colors

size : Em
size = em 1

snippets : List Snippet
snippets =
    [ class Grid
          [ property "table-layout" "fixed"
          , property "border-spacing" "0"
          , backgroundColor (hex Colors.white)
          , property "cell-spacing" "0"
          , descendants
              [ td
                    [ width size
                    , height size
                    , padding zero
                    ]
              ]
          ]
    ]
