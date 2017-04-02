module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Phoenix.Internal.PresenceTest as InternalPresenceTest


all : Test
all =
    describe "elm-phoenix"
        [ InternalPresenceTest.all
        ]
