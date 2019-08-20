## Install Scenic dependencies

```
brew update
brew install glfw3 glew pkg-config
mix archive.install hex scenic_new
```

## Create a new project

```
mix scenic.new legend_of_elixir
```

## Installing dependencies

```
cd legend_of_elixir
mix do deps.get
```

## Running

### Server
```
iex --name "server@192.168.244.58" --cookie "my-secret" -S mix
```

### Client
```
iex --name "client@192.168.244.58" --cookie "my-secret" -S mix
```

## Gotchas

There's a bug for `handle_continue/2` on the current version on hex.pm.
The latest version on Github has a fix:

```
[
  {:scenic, github: "boydm/scenic", ref: "7a1bca453c4d96b64f2593ccaf2ea0e0b88fcc75", override: true},
  {:scenic_driver_glfw, github: "boydm/scenic_driver_glfw", ref: "e744f89a929278be41339b25364ea84768674359", targets: :host},
]
```
