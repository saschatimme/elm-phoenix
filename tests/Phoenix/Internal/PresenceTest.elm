module Phoenix.Internal.PresenceTest exposing (all)

import Test exposing (..)
import Expect
import Phoenix.Internal.Channel as InternalChannel exposing (InternalChannel)
import Dict
import Phoenix.Channel as Channel
import Json.Encode as JE
import Phoenix.Internal.Presence exposing (..)


type alias UserMeta =
    { status : UserStatus
    }


type UserStatus
    = Away
    | Online


encodeUserMeta : UserMeta -> JE.Value
encodeUserMeta userMeta =
    JE.object
        [ ( "status", JE.string (toString userMeta.status) ) ]


userStates =
    { user123 =
        PresenceStateMetaWrapper
            [ PresenceStateMetaValue "abc" <| encodeUserMeta { status = Away }
            , PresenceStateMetaValue "def" <| encodeUserMeta { status = Online }
            ]
    , user456 =
        PresenceStateMetaWrapper
            [ PresenceStateMetaValue "ghi" <| encodeUserMeta { status = Online }
            ]
    , user789 =
        PresenceStateMetaWrapper
            [ PresenceStateMetaValue "xyz" <| encodeUserMeta { status = Online }
            ]
    }


all : Test
all =
    describe "InternalPresence"
        [ describe "syncPresenceDiff"
            [ syncPresenceDiffTest "no change"
                { before =
                    Dict.fromList
                        [ ( "123", userStates.user123 )
                        , ( "456", userStates.user456 )
                        ]
                , diff =
                    { leaves = Dict.empty, joins = Dict.empty }
                , after =
                    Dict.fromList
                        [ ( "123", userStates.user123 )
                        , ( "456", userStates.user456 )
                        ]
                }
            , syncPresenceDiffTest "user joins"
                { before =
                    Dict.fromList
                        [ ( "123", userStates.user123 )
                        , ( "456", userStates.user456 )
                        ]
                , diff =
                    { leaves = Dict.empty
                    , joins =
                        Dict.fromList
                            [ ( "789", userStates.user789 ) ]
                    }
                , after =
                    Dict.fromList
                        [ ( "123", userStates.user123 )
                        , ( "456", userStates.user456 )
                        , ( "789", userStates.user789 )
                        ]
                }
            , syncPresenceDiffTest "user leaves"
                { before =
                    Dict.fromList
                        [ ( "123", userStates.user123 )
                        , ( "456", userStates.user456 )
                        ]
                , diff =
                    { leaves =
                        Dict.fromList
                            [ ( "456", userStates.user456 )
                            ]
                    , joins = Dict.empty
                    }
                , after =
                    Dict.fromList
                        [ ( "123", userStates.user123 )
                        ]
                }
            ]
        ]


syncPresenceDiffTest :
    String
    -> { before : PresenceState, diff : PresenceDiff, after : PresenceState }
    -> Test
syncPresenceDiffTest name { before, diff, after } =
    test name <|
        \() ->
            Expect.equal
                (syncPresenceDiff diff before)
                after
