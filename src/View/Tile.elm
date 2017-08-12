module View.Tile exposing (..)

import Html exposing (text, button, strong)
import Html.Events
import Html.Events.Custom
import Html.Attributes exposing (type_, style)
import Styles.Colors as Colors
import Styles.Classes as Classes exposing (class, classList)
import Tile
import Msgs

color : Int -> String
color number =
    case number of
        1 -> Colors.blue

        2 -> Colors.green

        3 -> Colors.red

        4 -> Colors.purple

        5 -> Colors.brown

        6 -> Colors.mint

        7 -> Colors.black

        8 -> Colors.grey

        _ -> "inherit"


view : Int -> Int -> Int -> Tile.Tile -> Html.Html Msgs.Msg
view row col number tile =
    let
        classes =
            classList [ (Classes.Tile, True)
                      , (Classes.Tile_unrevealed, (not tile.isRevealed))]

        tileButton content =
            button [ type_ "button"
                   , classes
                   , Html.Events.onClick (Msgs.ClickTile row col)
                   , Html.Events.Custom.onRightClick (Msgs.RightClickTile row col)
                   ]
                content
    in
    if tile.isRevealed then
        if tile.isMine then
            tileButton [ strong
                             [style [("color", Colors.red)] ]
                             [text "*"] ]
        else
            if number == 0 then
                tileButton [ ]
            else
                tileButton
                    [ strong
                          [ style [ ("color", color number)] ]
                          [ text (toString number) ] ]
    else
        if tile.isMarked then
            tileButton [ text "M" ]
        else
            tileButton [ ]
