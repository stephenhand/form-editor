module TabbedPane exposing (view)

import Html exposing (Html, div, input)
import Html.Attributes exposing (type_, name)

type Msg = String



view: List (String, Html) -> Html Msg

view tabDefs =
    div (List.map \t->
        let
            (tabName, _) = t
        in
            (input [
                type_ "radio"
            ] [])
            tabDefs )  []

