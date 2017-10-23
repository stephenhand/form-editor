port module BuildCss exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import AppStyles


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "app-styles.css", Css.File.compile [ AppStyles.css ] )
        ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure