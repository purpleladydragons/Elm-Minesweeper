module View exposing (..)

import Html exposing (Html, text, div, table, tbody, tr, td)
import Msgs exposing (Msg)
import Game exposing (Game)
import Matrix
import Tile
import View.Tile
import Grid
import Styles.Classes as Classes exposing (class, classList)

view : Game -> Html Msg
view game = div [] [ viewGrid game.grid ]

viewGrid : Matrix.Matrix Tile.Tile -> Html Msg
viewGrid grid =
    div []
        [ table
              [ class [Classes.Grid] ]
              [ tbody []
                    (List.indexedMap
                         (viewRow grid)
                         (Matrix.toListOfLists grid)) ] ]

viewRow : Grid.Grid -> Int -> List Tile.Tile -> Html Msg
viewRow grid rowIndex row =
    tr []
        (List.indexedMap
             (\colIndex ->
                  let numNeighbors =
                      Grid.tileNumber grid rowIndex colIndex
                  in
                  viewTile rowIndex colIndex numNeighbors)
             row)

-- how to show counts? should tiles store that info?
-- should it be computed each time?
viewTile : Int -> Int -> Int -> Tile.Tile -> Html Msg
viewTile row col number tile =
    td []
        [View.Tile.view row col number tile]
