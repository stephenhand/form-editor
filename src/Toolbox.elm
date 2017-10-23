module Toolbox exposing (..)
import Html exposing (Html, div, text)
import Html.Attributes exposing (id, value, property, attribute)

type alias FormComponent = {
    rawXml:String,
    componentType:ComponentType,
    x:Int,
    y:Int
    }

type ComponentType =
    Label

type alias State = {id:String}

type alias Msg = String

componentFromXML:String->FormComponent

componentFromXML xmlString ={
    rawXml = xmlString,
    componentType=Label,
    x=0,
    y=0
    }

reposition:FormComponent->Int->Int->FormComponent

reposition component x y  =
    {component | x = x,
                 y = y}

componentToolboxIconView:ComponentType->Html Msg

componentToolboxIconView componentType =
    case componentType
        of Label ->
            div [
                attribute "draggable" ""
            ] [
                text "Label"
            ]

initialise:String->State

initialise id = {id=id}

view:State -> Html Msg

view state =
    div [
        id state.id

    ]
    [
        componentToolboxIconView Label
    ]