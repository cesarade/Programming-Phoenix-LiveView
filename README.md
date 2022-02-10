# Programming-Phonex-LiveView" 

Para configurar la base de datos:

```bash
$ mix ecto.create
```

Para ejecutar el servidor:

```bash
$ iex -S mix phx.server
```

## the LiveView Lifecycle

LiveView are about state, and LiveView manages state in structs called sockets. The module `Phoenix.LiveView.Socket` creates these structs.

The socket struct has all of data the Phoenix needs to manage a LiveView connection. You'll interact with most frequently in your live views, is `assigns{}`. That's where you'll keep all of a given live view's custom data.

The LiveView lifecycle begins in the Phoenix router (live router). That process will initialize the live view's state by setting up the socket in a function called `mount/3`. Then, the live view render that state in some markup for the client.

```bash
Router > Index.mount > Index.render
```
