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
Since this package is an [effect](https://guide.elm-lang.org/architecture/effects/) manager it is at the moment not aviable via elm package. Thus the recommended way to install the package is to use [elm-github-install](https://github.com/gdotdesign/elm-github-install). Simply add in `elm-package.json` `"saschatimme/elm-phoenix": "0.2.1 <= v < 1.0.0"` to your dependencies:
```
# elm-package.json
{
  ...
  "dependencies": {
    ...
    "saschatimme/elm-phoenix": "0.2.1 <= v < 1.0.0",
    ...
  }
  ...
}
```
and install the package with `elm-github-install`.

**Please note:** Depending on your setup the example Phoenix app in this repo can cause errors. One solution would be to simply delete the `example` folder. See [this issue](https://github.com/saschatimme/elm-phoenix/issues/7) for more details.

The last compatible version with Elm 0.17 is `0.1.0`.

## Documentation
You can find the documentation [here](https://saschatimme.github.io/elm-phoenix).

## Example
A simple example chat application can be found [here](https://github.com/saschatimme/elm-phoenix/tree/master/example).

## Contributing
Contributions are welcome! If you get stuck or don't understand some details just get in touch.
If you want to contribute but don't know what here are some ideas:

- Add Presence support 
- Improve the example app

## Feedback
If you use the package in your project, I would love to hear how your experience is and if you have some ideas for improvements!
