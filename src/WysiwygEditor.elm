module WysiwygEditor exposing (initialise, view, update, State, Msg, Action(..))

import Result exposing (..)
import Html exposing (Html, div, text)
import Html.Events exposing (onInput)
import Html.Attributes exposing (id, value, property)

import Json.Encode

import Xslt

type alias Msg = (String, Action)

type Action = SourcesUpdated String String

type alias State = { xml:String, xslt:String, id:String }


initialise:String -> String -> String -> State

initialise id startXml startXslt =
    { xml = startXml,
      xslt = startXslt,
      id = id }

update : Action -> State -> State
update action currentState =
    case action of
        SourcesUpdated newXml newXslt ->
            {currentState | xml = newXml,
                            xslt = newXslt}


view : State -> Html Msg

view state =
    let
        action:Html Action
        action=div [(property "innerHTML"
            (Json.Encode.string (case (Xslt.transform state.xslt state.xml) of
                Ok transformed ->
                    transformed
                Err error ->
                    toString error
            ))), id state.id] []
    in
    Html.map (\a -> (state.id, a)) action