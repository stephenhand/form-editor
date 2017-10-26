module TabbedPaneTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, list, int, string)
import Test exposing (..)

suite : Test
suite =
    describe "TabbedPane module"
        [
            describe "TabbedPane"
                [test "dummy test" <|
                    \_ -> Expect.equal "dummy" "dummy"
                ]
        ]