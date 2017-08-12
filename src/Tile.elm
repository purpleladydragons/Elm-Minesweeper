module Tile exposing (..)

type alias Tile =
    { isMine : Bool
    , isRevealed : Bool
    , isMarked : Bool
    }

type Action = Reveal | Toggle

init : Bool -> Tile
init isMine =
    { isMine = isMine
    , isRevealed = False
    , isMarked = False
    }

makeBomb : Tile -> Tile
makeBomb model =
    { model |
          isMine = True
    }

reveal : Tile -> Tile
reveal model =
    { model |
          isRevealed = True
    }

toggle : Tile -> Tile
toggle model =
    { model |
          isMarked = (not (model.isMarked))}

