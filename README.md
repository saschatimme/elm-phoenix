# elm-phoenix

An Elm client for [Phoenix](http://www.phoenixframework.org) Channels.

This package makes it easy to connect to Phoenix Channels, but in a more declarative manner than the Phoenix Socket Javascript library. Simply provide a `Socket` and a list of `Channel`s you want to join and this library handles the unpleasent parts like opening a connection, joining channels, reconnecting after a network error and managing replies.

## Getting Started

Declare a socket you want to connect to and the channels you want to join. The effect manager will open the socket connection, join the channels. See `Phoenix.Socket` and `Phoenix.Channel` for more configuration details.

```elm
import Phoenix
import Phoenix.Socket as Socket
import Phoenix.Channel as Channel

type Msg = NewMsg Value | ...

socket =
    Socket.init "ws://localhost:4000/socket/websocket"

channel =
    Channel.init "room:lobby"
        -- register an handler for messages with a "new_msg" event
        |> Channel.on "new_msg" NewMsg

subscriptions model =
    Phoenix.connect socket [channel]
```

## Example
A simple example chat application can be found [here](https://github.com/saschatimme/elm-phoenix/tree/master/example).
