module SourceEditor exposing (initialise, view, update, State, Msg, Action(..))

import Html exposing (Html, textarea, div, text)
import Html.Events exposing (onInput)
import Html.Attributes exposing (id, value)

type alias State = { content:String, id:String }

type Action = XmlUpdated String

type alias Msg = (String, Action)

initialise:String -> String -> State

initialise id startContent =
    { content = startContent, id = id }

update : Action -> State -> State
update action currentState =
    case action of
        XmlUpdated newXML ->
            {currentState | content = newXML}

view : State -> Html Msg

view state =
    let
        action:Html Action
        action=textarea [id state.id, onInput XmlUpdated, value state.content] []
    in
    Html.map (\a -> (state.id, a)) action