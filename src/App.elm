module App exposing (main)

import SourceEditor exposing (Msg)

import WysiwygEditor exposing (Msg)
import Html exposing (Html, div)

main =
    Html.program {
        init = init,
        subscriptions = subscriptions,
        update = update,
        view = view
    }

type alias Model = {
    currentDefinitionXml : String,
    currentWysiwygXslt : String,
    definitionSourceEditor : SourceEditor.State,
    xsltSourceEditor : SourceEditor.State,
    wysiwygEditor : WysiwygEditor.State}


init : (Model, Cmd msg)


init =  ({  currentDefinitionXml = "" ,
            currentWysiwygXslt = "",
            definitionSourceEditor=SourceEditor.initialise "xml" "",
            xsltSourceEditor=SourceEditor.initialise "xslt" "",
            wysiwygEditor=WysiwygEditor.initialise "wysiwyg" "" ""}, Cmd.none)

subscriptions : Model -> Sub Msg

subscriptions model =  Sub.none

type Msg =
    SourceEditorMsg SourceEditor.Msg |
    WysiwgEditorMsg WysiwygEditor.Msg

update : Msg -> Model -> (Model, Cmd msg)

update action model =
    (
    case action of
        SourceEditorMsg sourceEditorMessage ->
            let
                (id, sourceEditorAction) = sourceEditorMessage
                xml:String
                xml=
                    case sourceEditorAction of
                        SourceEditor.XmlUpdated newXml ->
                            case id of
                                "xml" ->
                                    newXml
                                _ ->
                                    model.currentDefinitionXml
                xslt:String
                xslt=
                    case sourceEditorAction of
                        SourceEditor.XmlUpdated newSource ->
                            case id of
                                "xslt" ->
                                    newSource
                                _ ->
                                    model.currentWysiwygXslt

            in
                {   currentDefinitionXml = xml,
                    currentWysiwygXslt = xslt,
                     definitionSourceEditor = SourceEditor.update (SourceEditor.XmlUpdated xml) model.definitionSourceEditor,
                     xsltSourceEditor =  SourceEditor.update (SourceEditor.XmlUpdated xslt) model.xsltSourceEditor,
                     wysiwygEditor = WysiwygEditor.update (WysiwygEditor.SourcesUpdated xml xslt) model.wysiwygEditor}
        _ -> model

    , Cmd.none)

view : Model -> Html Msg
view model = div [] [
    Html.map SourceEditorMsg (SourceEditor.view model.xsltSourceEditor),
    Html.map SourceEditorMsg (SourceEditor.view model.definitionSourceEditor),
    Html.map WysiwgEditorMsg (WysiwygEditor.view model.wysiwygEditor)]
