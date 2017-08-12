module Styles.Classes exposing (..)

import Html exposing (Attribute)
import Html.CssHelpers as CssHelpers exposing (Namespace)

type Class
    = Tile
    | Tile_unrevealed
    | Tile_mine
    | Tile_flag
    | Grid

namespace : String
namespace = "minesweeper-"

helpers : Namespace String class id msg
helpers = CssHelpers.withNamespace namespace

class : List Class -> Attribute msg
class = helpers.class

classList : List (Class, Bool) -> Attribute msg
classList = helpers.classList
