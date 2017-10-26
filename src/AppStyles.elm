module AppStyles exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, li)
import Css.Namespace exposing (namespace)

type CssClasses
    = TabContent |
    ActiveTabContent |
    SplitTabContent |
    Tab |
    TabStrip


css =
    (stylesheet << namespace "form-editor-app")
    [
        class TabStrip [

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