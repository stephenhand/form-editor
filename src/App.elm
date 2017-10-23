module App exposing (main)

import Html exposing (Html, div)
import Html.Attributes exposing (class, classList, id)
import Html.CssHelpers

import SourceEditor exposing (Msg)
import WysiwygEditor exposing (Msg)
import Toolbox

import AppStyles

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
    wysiwygEditor : WysiwygEditor.State,
    toolbox : Toolbox.State}


init : (Model, Cmd msg)


init =  ({  currentDefinitionXml = "" ,
            currentWysiwygXslt = "",
            definitionSourceEditor=SourceEditor.initialise "xml" "",
            xsltSourceEditor=SourceEditor.initialise "xslt" "",
            wysiwygEditor=WysiwygEditor.initialise "wysiwyg" "" "",
            toolbox=Toolbox.initialise "toolbox"}, Cmd.none)

subscriptions : Model -> Sub Msg

subscriptions model =  Sub.none

type Msg =
    SourceEditorMsg SourceEditor.Msg |
    WysiwygEditorMsg WysiwygEditor.Msg |
    ToolboxMsg Toolbox.Msg

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
                     wysiwygEditor = WysiwygEditor.update (WysiwygEditor.SourcesUpdated xml xslt) model.wysiwygEditor,
                     toolbox = model.toolbox}
        _ -> model

    , Cmd.none)



{ id, class, classList } =
    Html.CssHelpers.withNamespace "form-editor-app"

view : Model -> Html Msg
view model = div [] [
    div [id AppStyles.TabStrip] [],
    div[classList [(AppStyles.TabContent, True), (AppStyles.ActiveTabContent, True)]] [
        Html.map SourceEditorMsg (SourceEditor.view model.xsltSourceEditor)
    ],
    div[classList [(AppStyles.TabContent, True)]] [
        Html.map SourceEditorMsg (SourceEditor.view model.definitionSourceEditor)
    ],
    div[classList [(AppStyles.TabContent, True)]] [
        Html.map WysiwygEditorMsg (WysiwygEditor.view model.wysiwygEditor)
    ],
    div[classList [(AppStyles.TabContent, True)]] [
        Html.map ToolboxMsg (Toolbox.view model.toolbox)
    ]]
