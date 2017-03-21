module Phoenix.Internal.Presence exposing (..)

import Json.Decode as JD exposing (Decoder, Value)
import Dict exposing (Dict)


type alias PresenceState =
    Dict PresenceKey PresenceStateMetaWrapper


type alias PresenceDiff =
    { leaves : PresenceState
    , joins : PresenceState
    }


type alias PresenceKey =
    String


type alias PresenceStateMetaWrapper =
    { metas : List PresenceStateMetaValue }


type alias PresenceStateMetaValue =
    { phx_ref : PresenceRef, payload : Value }


type alias PresenceRef =
    String


getPresenceState : PresenceState -> Dict String (List Value)
getPresenceState presenceState =
    let
        getMetas { metas } =
            metas

        getPayload presenceKey presenceStateMetaWrapper =
            List.map .payload (getMetas presenceStateMetaWrapper)
    in
        Dict.map getPayload presenceState


syncPresenceDiff : PresenceDiff -> PresenceState -> PresenceState
syncPresenceDiff presenceDiff presenceState =
    let
        mergeJoins joins state =
            let
                mergeMetaWrappers joinMetaWrapper stateMetaWrapper =
                    PresenceStateMetaWrapper (joinMetaWrapper.metas ++ stateMetaWrapper.metas)

                addedStep key joinMetaWrapper addedMetaWrappers =
                    Dict.insert key joinMetaWrapper addedMetaWrappers

                retainedStep key joinMetaWrapper stateMetaWrapper addedMetaWrappers =
                    Dict.insert key (mergeMetaWrappers joinMetaWrapper stateMetaWrapper) addedMetaWrappers

                unchangedStep key stateMetaWrapper addedMetaWrappers =
                    Dict.insert key stateMetaWrapper addedMetaWrappers
            in
                Dict.merge addedStep retainedStep unchangedStep joins state Dict.empty

        mergeLeaves leaves state =
            let
                mergeMetaWrappers leaves stateKey stateMetaWrapper =
                    case Dict.get stateKey leaves of
                        Nothing ->
                            stateMetaWrapper

                        Just leaveMetaWrapper ->
                            let
                                leaveRefs =
                                    List.map .phx_ref leaveMetaWrapper.metas
                            in
                                stateMetaWrapper.metas
                                    |> List.filter
                                        (\metaValue ->
                                            not (List.any (\phx_ref -> metaValue.phx_ref == phx_ref) leaveRefs)
                                        )
                                    |> PresenceStateMetaWrapper
            in
                state
                    |> Dict.map (mergeMetaWrappers leaves)
                    |> Dict.filter (\_ metaWrapper -> metaWrapper.metas /= [])
    in
        presenceState
            |> mergeJoins presenceDiff.joins
            |> mergeLeaves presenceDiff.leaves


decodePresenceDiff : Value -> Result String PresenceDiff
decodePresenceDiff payload =
    JD.decodeValue presenceDiffDecoder payload


decodePresenceState : Value -> Result String PresenceState
decodePresenceState payload =
    JD.decodeValue presenceStateDecoder payload


presenceDiffDecoder : Decoder PresenceDiff
presenceDiffDecoder =
    JD.map2 PresenceDiff
        (JD.field "leaves" <| presenceStateDecoder)
        (JD.field "joins" <| presenceStateDecoder)


presenceStateDecoder : Decoder PresenceState
presenceStateDecoder =
    JD.dict presenceStateMetaWrapperDecoder


presenceStateMetaWrapperDecoder : Decoder PresenceStateMetaWrapper
presenceStateMetaWrapperDecoder =
    JD.map PresenceStateMetaWrapper
        (JD.field "metas" <| JD.list presenceStateMetaValueDecoder)


presenceStateMetaValueDecoder : Decoder PresenceStateMetaValue
presenceStateMetaValueDecoder =
    let
        createFinalRecord phxRef payload =
            JD.succeed (PresenceStateMetaValue phxRef payload)

        decodeWithPhxRef phxRef =
            JD.andThen (createFinalRecord phxRef) JD.value
    in
        JD.andThen decodeWithPhxRef (JD.field "phx_ref" JD.string)
