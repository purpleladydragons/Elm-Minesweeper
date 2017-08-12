module Grid exposing (..)

import Set
import Matrix
import Tile exposing (Tile)
import Random.Pcg as Random exposing (Seed)

type alias Grid = Matrix.Matrix Tile.Tile

init : Int -> Int -> Int -> Seed -> (Seed, Grid)
init height width numMines seed =
    let grid =
        Matrix.init height width (\row col -> Tile.init False)
    in
    placeMines numMines Set.empty (seed, grid)

tileNumber : Grid -> Int -> Int -> Int
tileNumber grid row col =
    Matrix.neighbors grid row col
        |> List.filter isTileMine
        |> List.length

placeMines : Int -> Set.Set (Int, Int) -> (Seed, Grid) -> (Seed, Grid)
placeMines numMines excludedCoords (seed, grid) =
    List.foldl
        (always (placeRandomMine excludedCoords))
        (seed, grid)
        (List.repeat numMines ())

placeRandomMine : Set.Set (Int, Int) -> (Seed, Grid) -> (Seed, Grid)
placeRandomMine excludedCoords (seed, grid) =
    let isAvailable (row, col) =
            case Matrix.get grid row col of
                Just tile ->
                    not (Set.member (row, col) excludedCoords)
                Maybe.Nothing ->
                    False

        rowGenerator =
            Random.int 0 (Matrix.width grid)

        colGenerator =
            Random.int 0 (Matrix.height grid)

        coordsGenerator =
            Random.pair rowGenerator colGenerator
                |> Random.filter isAvailable

        ( (row, col), newSeed ) =
            Random.step coordsGenerator seed

        newGrid =
            Matrix.update grid row col (\tile -> { tile | isMine = True })
    in
    (newSeed, newGrid)

isTileMine : Tile.Tile -> Bool
isTileMine tile = tile.isMine

reveal : Int -> Int -> Grid -> Grid
reveal row col grid =
    case Matrix.get grid row col of
        Just tile ->
            if not tile.isMarked then
                if tileNumber grid row col == 0 then
                    revealNeighbors grid row col
                else
                    revealSingle grid row col
            else
                grid
        Maybe.Nothing ->
            grid


revealSingle : Grid -> Int -> Int -> Grid
revealSingle grid row col =
    case Matrix.get grid row col of
        Just tile ->
            Matrix.update grid row col Tile.reveal
        Maybe.Nothing -> grid

revealJustNeighbors : Int -> Int -> Grid -> Grid
revealJustNeighbors row col grid =
    case Matrix.get grid row col of
        Just tile ->
            let
                number =
                    tileNumber grid row col

                neighbors =
                    Matrix.neighborCoords grid row col

                flags =
                    Matrix.neighbors grid row col
                        |> List.filter (\tile -> tile.isMarked)
            in
            if number == 0 || List.length flags /= number then
                grid
            else
                List.foldl (uncurry reveal) grid neighbors

        Maybe.Nothing -> grid

revealNeighbors : Grid -> Int -> Int -> Grid
revealNeighbors grid row col =
    let (_, newGrid) =
        recursiveReveal row col (Set.empty, grid)
    in
    newGrid

recursiveReveal : Int -> Int
                -> (Set.Set (Int, Int), Grid)
                -> (Set.Set (Int, Int), Grid)
recursiveReveal row col (seenCoords, grid) =
    if Set.member (row, col) seenCoords then
        (seenCoords, grid)
    else
        case Matrix.get grid row col of
            Just tile ->
                let
                    number =
                        tileNumber grid row col

                    newGrid =
                        revealSingle grid row col

                    newSeenCoords =
                        Set.insert (row, col) seenCoords

                    neighbors =
                        Matrix.neighborCoords grid row col
                in
                if number == 0 then
                    List.foldl
                        (uncurry recursiveReveal)
                        (newSeenCoords, newGrid)
                        neighbors
                else
                    (newSeenCoords, newGrid)

            Maybe.Nothing ->
                (seenCoords, grid)

toggle : Int -> Int -> Grid -> Grid
toggle row col grid =
    Matrix.update grid row col Tile.toggle

isGridWon : Grid -> Bool
isGridWon grid =
    Matrix.all grid isTileCorrectlyMarked

isGridLost : Grid -> Bool
isGridLost grid =
    Matrix.any grid isRevealedMine

isTileCorrectlyMarked : Tile -> Bool
isTileCorrectlyMarked tile =
    tile.isMine && tile.isMarked

isRevealedMine : Tile -> Bool
isRevealedMine tile =
    tile.isMine && tile.isRevealed
