module AppStyles exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, li)
import Css.Namespace exposing (namespace)

type CssClasses
    = TabContent |
    ActiveTabContent |
    SplitTabContent |
    Tab


type CssIds
    = TabStrip

css =
    (stylesheet << namespace "form-editor-app")
    [
        id TabStrip [

        ],
        class TabContent [
            position relative,
            width (pct 100),
            display none
        ],
        class ActiveTabContent [
            display block
        ]
    ]