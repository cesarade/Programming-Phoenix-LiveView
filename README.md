# Programming Phoenix LiveView

## the LiveView Lifecycle

LiveView are about state, and LiveView manages state in structs called sockets. The module `Phoenix.LiveView.Socket` creates these structs.

The socket struct has all of data the Phoenix needs to manage a LiveView connection. You'll interact with most frequently in your live views, is `assigns{}`. That's where you'll keep all of a given live view's custom data.

The LiveView lifecycle begins in the Phoenix router (live router). That process will initialize the live view's state by setting up the socket in a function called `mount/3`. Then, the live view render that state in some markup for the client.

```bash
Router > Index.mount > Index.render
```
### Mount and Render the Live View

When your Phoenix app receives a request in a live router, that will invoke module's `mount/3` function. The `mount/3` function is responsible for establishing the initial state for the live view by population the socket assings

```bask
def mount(_params, _session, socket) do
  {:ok, assign(socket, score: 0, message: "Make a guess:")}
end
```

That means out initial socket looks something like this:

```bash
%Socket{
  assigns: %{
    score: 0,
    message: "Make a guess:"
  }
}
```

After the initial `mount` finishes, LiveView the passes the value of the socket to `render/1` function.

```bash
def render(assigns) do
    ~L'''
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
    <%= for n <- 1..10 do %>
      <a href="#" phx-click="guess" phx-value-number=<%= n %>><%= n %><a/>
    <% end %>
    </h2>
    '''
  end
```

### Handle Events

```bash
<a href="#" phx-click="guess" phx-value-number=<%= n %>><%= n %></a>
```






