module Styles.Main exposing (stylesheet)

import Css exposing (Snippet, Stylesheet)
import Css.Namespace
import Styles.Global as Global
import Styles.Tile as Tile
import Styles.Grid as Grid
import Styles.Classes

allSnippets : List Snippet
allSnippets =
    Global.snippets
    ++ Tile.snippets
    ++ Grid.snippets

stylesheet : Stylesheet
stylesheet = allSnippets
             |> Css.Namespace.namespace Styles.Classes.namespace
             |> Css.stylesheet
