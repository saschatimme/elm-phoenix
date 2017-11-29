module Phoenix.Presence exposing (Presence, create, onChange, onJoins, onLeaves, map)

{-| Presence is an extension for channels to support the Presence feature of Phoenix.


# Definition

@docs Presence


# Helpers

@docs create, onChange, onJoins, onLeaves, map

-}

import Dict exposing (Dict)
import Json.Decode as JD exposing (Decoder, Value)


-- Presence


{-| Representation of a Presence configuration
-}
type alias Presence msg =
    PhoenixPresence msg


type alias PhoenixPresence msg =
    { onChange : Maybe (Dict String (List Value) -> msg)
    , onJoins : Maybe (Dict String (List Value) -> msg)
    , onLeaves : Maybe (Dict String (List Value) -> msg)
    }


{-| Create a Presence configuration
-}
create : PhoenixPresence msg
create =
    { onChange = Nothing
    , onJoins = Nothing
    , onLeaves = Nothing
    }


{-| This will be called each time the Presence state changes. The `Dict` contains as keys your presence keys and
as values a list of the payloads you sent from the server.
If you have on the elixir side `Presence.track(socket, user_name, %{online_at: now()})`
then an example would be a Dict with

    { "user1": [{online_at: 1491493666123}]
    , "user2": [{online_at: 1491492646123}, {online_at: 1491492646624}]
    }

-}
onChange : (Dict String (List Value) -> msg) -> PhoenixPresence msg -> PhoenixPresence msg
onChange func presence =
    { presence | onChange = Just func }


{-| This will be called each time user some user joins. This callback is useful to have special events
if a user joins. To obtain a list of all users use `onChange`.
-}
onJoins : (Dict String (List Value) -> msg) -> PhoenixPresence msg -> PhoenixPresence msg
onJoins func presence =
    { presence | onJoins = Just func }


{-| This will be called each time user some user leaves. This callback is useful to have special events
if a user leaves. To obtain a list of all users use `onChange`.
-}
onLeaves : (Dict String (List Value) -> msg) -> PhoenixPresence msg -> PhoenixPresence msg
onLeaves func presence =
    { presence | onLeaves = Just func }


{-| Maps the callbacks
-}
map : (a -> b) -> PhoenixPresence a -> PhoenixPresence b
map func pres =
    let
        f =
            Maybe.map ((<<) func)
    in
        { pres | onChange = f pres.onChange, onJoins = f pres.onJoins, onLeaves = f pres.onLeaves }
