module View exposing (..)

import Dom
import Html exposing (Html, text, div, table, tbody, tr, td, span, select, option)
import Html.Attributes exposing (selected, value, id, title)
import Html.Events.Custom exposing (onChange)
import Msgs exposing (Msg)
import Game exposing (Game)
import Matrix
import Tile
import View.Tile
import Grid exposing (Grid)
import Styles.Classes as Classes exposing (class, classList)

widthFieldId : Dom.Id
widthFieldId = "widthInput"

heightFieldId : Dom.Id
heightFieldId = "heightInput"

minesFieldId : Dom.Id
minesFieldId = "minesInput"

view : Game -> Html Msg
view game = div [] [ viewMenu game.grid
                   , viewGrid game.grid ]

viewMenu : Grid -> Html Msg
viewMenu grid =
    let
        sizeFields =
            span []
                [ sizeSelect
                      "Grid Width"
                      widthFieldId
                      Grid.minWidth
                      Grid.maxWidth
                      (Matrix.width grid)
                      Msgs.ChangeWidthSelect
                , sizeSelect
                      "Grid Height"
                      heightFieldId
                      Grid.minHeight
                      Grid.maxHeight
                      (Matrix.height grid)
                      Msgs.ChangeHeightSelect
                ]

        minesField =
            div [] []
    in
    div [] [ sizeFields
           , minesField
           ]

sizeSelect : String -> Dom.Id -> Int -> Int -> Int -> (String -> msg) -> Html msg
sizeSelect titleString idString minSize maxSize currentSize msg =
    let
        options =
            List.range minSize maxSize
                |> List.map (sizeOption currentSize)
    in
    select
        [ id idString
        , title titleString
        , onChange msg
        ]
        options

sizeOption : Int -> Int -> Html msg
sizeOption currentSize size =
    option [ value (toString size), selected (size == currentSize) ]
        [ text (toString size) ]

viewGrid : Matrix.Matrix Tile.Tile -> Html Msg
viewGrid grid =
    div []
        [ table
              [ class [Classes.Grid] ]
              [ tbody []
                    (List.indexedMap
                         (viewRow grid)
                         (Matrix.toListOfLists grid)) ] ]

viewRow : Grid -> Int -> List Tile.Tile -> Html Msg
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
