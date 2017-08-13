module Game exposing (..)

import Grid
import Random.Pcg as Random exposing (Seed)

type Status = Won | Lost | Playing

type alias Game =
    { grid : Grid.Grid
    , status : Status
    , seed : Seed
    , numMines : Int
    }

createGame : Int -> Int -> Int -> Seed -> Game
createGame width height numMines seed =
    let (newSeed,grid) =
        Grid.init height width numMines seed
    in
    { grid = grid
    , status = Playing
    , seed = newSeed
    , numMines = numMines
    }
