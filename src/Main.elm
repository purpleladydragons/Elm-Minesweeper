module Main exposing (..)

import Html exposing (program)
import Game exposing (Game, createGame)
import Grid
import Msgs exposing (Msg)
import Matrix
import Random.Pcg as Random exposing (Seed)
import View

init : (Game, Cmd Msg)
init =
    let seed =
        Random.initialSeed 1234
    in
    (createGame 18 18 40 seed, Cmd.none)

-- do this
subscriptions : Game -> Sub Msg
subscriptions game = Sub.none

update : Msg -> Game -> (Game, Cmd Msg)
update msg game =
    case msg of
        Msgs.ClickTile row col ->
            clickTile row col game

        Msgs.RightClickTile row col ->
            rightClickTile row col game

rightClickTile : Int -> Int -> Game -> (Game, Cmd Msg)
rightClickTile row col game =
    case Matrix.get game.grid row col of
        Just tile ->
            if not tile.isRevealed then
                let newGrid = Grid.toggle row col game.grid in
                ( {game | grid = newGrid}, Cmd.none)
            else
                (game, Cmd.none)

        Maybe.Nothing -> (game, Cmd.none)

clickTile : Int -> Int -> Game -> (Game, Cmd Msg)
clickTile row col game =
    case Matrix.get game.grid row col of
        Just tile ->
            if tile.isMarked then
                (game, Cmd.none)
            else
                -- TODO check game status after the reveal
                if tile.isRevealed then
                    if Grid.tileNumber game.grid row col == 0 then
                        (game, Cmd.none)
                    else
                        let newGrid =
                            Grid.revealJustNeighbors row col game.grid
                        in
                        ({game | grid = newGrid}, Cmd.none)
                else
                    let newGrid =
                        Grid.reveal row col game.grid
                    in
                    let updatedGame =
                            { game | grid = newGrid }
                    in
                    (updatedGame, Cmd.none)


        Maybe.Nothing ->
            (game, Cmd.none)


main : Program Never Game Msg
main = program { init = init
               , view = View.view
               , update = update
               , subscriptions = subscriptions
               }
