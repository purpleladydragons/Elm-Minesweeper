module Html.Events.Custom exposing (..)

import Html exposing (Attribute)
import Html.Events exposing (Options)
import Json.Decode as Decode 

onRightClick : msg -> Attribute msg
onRightClick tagger =
    Html.Events.onWithOptions "contextmenu"
        { stopPropagation = True, preventDefault = True }
        (Decode.succeed tagger)

onChange : (String -> msg) -> Attribute msg
onChange tagger =
    Html.Events.on "change"
        (Decode.map tagger Html.Events.targetValue)
