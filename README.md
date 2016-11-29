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

## Installation:
Since this package is an [effect manager](https://guide.elm-lang.org/effect_managers/) it is at the moment not aviable via elm package. Thus the recommended way to install the package is to use [elm-github-install](https://github.com/gdotdesign/elm-github-install). Simply add in `elm-package.json` `"saschatimme/elm-phoenix": "0.2.0 <= v < 1.0"` to your dependencies:
```
# elm-package.json
{
  ...
  "dependencies": {
    ...
    "saschatimme/elm-phoenix": "0.2.0 <= v < 1.0",
    ...
  }
  ...
}
```
and install the package with `elm-github-install`.

The last compatible version with Elm 0.17 is `0.1.0`.

## Documentation
Everything is prepared such that the package has the same nice documentation as packages on [elm-package](http://package.elm-lang.org).
As a workaround I included the generated [`documentation.json`](https://github.com/saschatimme/elm-phoenix/blob/master/documentation.json) so that you can preview it at http://package.elm-lang.org/help/docs-preview.

## Example
A simple example chat application can be found [here](https://github.com/saschatimme/elm-phoenix/tree/master/example).

## Contributing
Contributions are welcome! If you get stuck or don't understand some details just get in touch.
If you want to contribute but don't know what here are some ideas:

- Add Presence support 
- Improve the example app

## Feedback
If you use the package in your project, I would love to hear how your experience is and if you have some ideas for improvements!
