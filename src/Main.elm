module Main exposing (..)

import Html exposing (program)
import Game exposing (Game, createGame)
import Grid
import Msgs exposing (Msg)
import Matrix
import Random.Pcg as Random exposing (Seed)
import View


seed : Random.Seed
seed = Random.initialSeed 1235

init : (Game, Cmd Msg)
init =
    (createGame 8 8 40 seed, Cmd.none)

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

        Msgs.ChangeWidthSelect string ->
            ( updateGridSize
                  (parseWidth game string)
                  (Matrix.height game.grid)
                  game
            , Cmd.none )

        Msgs.ChangeHeightSelect string ->
            ( updateGridSize
                  (Matrix.width game.grid)
                  (parseHeight game string)
                  game
            , Cmd.none )

updateGridSize : Int -> Int -> Game -> Game
updateGridSize width height game =
    createGame width height game.numMines seed

parseWidth : Game -> String -> Int
parseWidth game string =
    String.toInt string
        |> Result.withDefault (Matrix.width game.grid)

parseHeight : Game -> String -> Int
parseHeight game string =
    String.toInt string
        |> Result.withDefault (Matrix.height game.grid)

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
                        checkGameStatus { game | grid = newGrid }
                else
                    let newGrid =
                        Grid.reveal row col game.grid
                    in
                    checkGameStatus { game | grid = newGrid }


        Maybe.Nothing ->
            (game, Cmd.none)

-- TODO this is a bad function name
checkGameStatus : Game -> (Game, Cmd Msg)
checkGameStatus game =
    if Grid.isGridWon game.grid then
        ( { game | status = Game.Won }, Cmd.none )
    else if Grid.isGridLost game.grid then
        ( { game | status = Game.Lost }, Cmd.none )
    else
        (game, Cmd.none)

main : Program Never Game Msg
main = program { init = init
               , view = View.view
               , update = update
               , subscriptions = subscriptions
               }
