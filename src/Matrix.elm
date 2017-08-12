module Matrix exposing (..)

import Array exposing (Array)

type alias Matrix a =
    Array (Array a)

init : Int -> Int -> (Int -> Int -> a) -> Matrix a
init height width f =
    Array.initialize height
        (\row ->
             Array.initialize width
             (\col -> f row col))

get : Matrix a -> Int -> Int -> Maybe a
get matrix row col =
    Array.get row matrix
        |> Maybe.andThen (Array.get col)

update : Matrix a -> Int -> Int -> (a -> a) -> Matrix a
update matrix row col f =
    get matrix row col
        |> Maybe.map
           (\current ->
                (Array.get row matrix
                |> Maybe.map
                   (\oldRow ->
                   Array.set col (f current) oldRow
                       |> (\newRow ->
                          Array.set row newRow matrix)
                   )
                |> Maybe.withDefault matrix
                )
           )
        |> Maybe.withDefault matrix

neighbors : Matrix a -> Int -> Int -> List a
-- TODO please generalize this monster
neighbors matrix row col =
    [ get matrix (row-1) col
    , get matrix (row-1) (col+1)
    , get matrix (row) (col+1)
    , get matrix (row+1) (col+1)
    , get matrix (row+1) (col)
    , get matrix (row+1) (col-1)
    , get matrix (row) (col-1)
    , get matrix (row-1) (col-1)
    ]
    |> List.filterMap identity

neighborCoords : Matrix a -> Int -> Int -> List (Int, Int)
neighborCoords matrix row col =
    [ ((row-1), col)
    , ((row-1), (col+1))
    , ((row), (col+1))
    , ((row+1), (col+1))
    , ((row+1), (col))
    , ((row+1), (col-1))
    , ((row), (col-1))
    , ((row-1), (col-1))
    ]

width : Matrix a -> Int
width matrix =
    Array.get 0 matrix
        |> Maybe.map Array.length
        |> Maybe.withDefault 0

height : Matrix a -> Int
height matrix =
    Array.length matrix

toListOfLists : Matrix a -> List (List a)
toListOfLists matrix =
    Array.map Array.toList matrix
        |> Array.toList


all : Matrix a -> (a -> Bool) -> Bool
all matrix f =
    not (any matrix (not << f))

any : Matrix a -> (a -> Bool) -> Bool
any matrix f =
    Array.length (filter matrix f) > 0

-- TODO this will append things in reverse order, do we like that?
filter : Matrix a -> (a -> Bool) -> Array a
filter matrix f =
    Array.foldl
        (\row accum ->
             Array.filter f row
             |> Array.append accum
        )
        Array.empty
        matrix
