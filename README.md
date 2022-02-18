# Fundamenmtos Depoaspdoas
introducciond de la materia

## Creacion de variables

## Condicional

asdjaksd

$$
\bar{x} = \sum_{i=1}^n x_i
$$


# Programming Phoenix LiveView

## The LiveView Lifecycle

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

You can see that we match only function calls where the first argument is "guess", and the second is a map with a key of "number". Those are the arguments we set in our phx-click and phx-value link attributes.

## Phoenix and Authentication

We'll generate the bulk og our code with the `phx.gen.auth` generator, and then we'll tweak that code to do what we want. This generator is by far the best solution for Phoenix authentication.

```bash
mix phx.gen.auth Accounts User users
```

The code `mix phx.gen.auth Accounts User users` built some migrations for us.

```bash
mix ecto.migrate
```
### Protect Routes with Plugs

The authentication service is defined in the file `lib/pento_web/controllers/user_auth.ex`. 

```bash
iex> exports PentaWeb.UserAuth
fetch_current_user/2
log_in_user/2
log_in_user/3
log_out_user/2
redirect_if_user_is_authenticated/2
require_authenticated_user/2
```
All of these functions are plugs. The last two plugs direct users between pages based on whether they are logged in or not.

auth/pento/lib/pento_web/router.ex

```bash
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_live_flash
  plug :put_root_layout, {PentoWeb.LayoutView, :root}
  plug :protect_from_forgery
  plug :put_secure_browser_headers
  plug :fetch_current_user
end
```

The `fetch_current_user/2` function plug will add a key in `assigns` called `current_user` if the user is logged in.

```bash
scope "/", PentoWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/guess", WrongLive

    get "/users/settings", UserSettingsController, :edit
    ...
 end 
```

## Generators: Contexts and Schemas

The Phoenix Live generator is a utility that generates code supporting full CRUD functionality for a given resource. This includes the backend schema and context code, as well as the frontend code including routes, LiveView and templates.

```bash
mix phx.gen.live Catalog Product products name:string description:string unit_price:float sku:integer:unique
```
We separate the concerns for each resource into two layers, the `boundary` and `core`. The `Catalog` context represents the boundary layer, it is the API through which external input can make its way into the application.

The `Product` schema, represents the application's core. The core is responsible for managing and interacting with the database.

The boundary code isn't just an API layer. It's the place we try to hold all uncertainty. Out context has at least these responsibilities:

* Access External Services: The context allows a single point of access for external services.
* Abstract Away Tedious Details: The context abstracts away tedious, inconvenient concepts.
* Handle uncertainty: The context handles uncertainty, often by using result tuples.
* Present a single, common API: The context provides a single access point for a family of services.

External services will always be accessed from the context. Accessing external services may result in failure, and managing this unpredictability is squarely the responsibility of the context. Our application’s database is an external service, and the Catalog context provides the service of database access.

Elixir will always use Ecto to transact against the database. But the work of using Ecto to cast and validate changesets, or execute common queries, can be repetitive. Phoenix contexts provide an API through which we can abstract away these tedious details, and our generated context is no different.

## Generators: Live Views and Templates

The `live` macro generates a route that ties a URL pattern to a given LiveView module. When a user visits the URL in the browser, the LiveView process starts up and renders a template for the client.

LiveView are called `behaviours`. The behaviours runs a specified application and calls your code according to a contract. The LiveView contract difines several callbacks. Some are optional, and you must impletment others.

When we say that `mount/3` happens before `render/1` in a live view, we don't mean `mount/3` actually calls `render/1`. We mean the `behaviours` call mount/3, and then render/1.

If we’ve defined an explicit render/ 1 function, the behaviour will use it. If not, LiveView will render a template based on the name of the live view file. There’s no explicit render/ 1 function defined in the ProductLive.Index live view, so our live view will render the template in the index.html.heex file

```bash
%{
  __changed__: %{greeting: true, products: true},
  flash: %{},
  greeting: "Welcome to Pento!",
  live_action: :index,
  products: [
    %Pento.Catalog.Product{
      ....
    }
  ]
}
```

Our LiveView’s index state is complete and ready to be rendered! Since our live view doesn’t implement a render function, the behaviour will fall back to the default render/ 1 function and render the template that matches the name of the LiveView file, pento/ pento_web/ live/ index.html.heex.

### Render Product Index State

LiveView’s built-in templates use the .heex extension. HEEx, is similar to EEX except that it is designed to minimize the amount of data sent down to the client over the WebSocket connection. Part of the job of these templates is to track state changes in the live view socket and only update portions of the template impacted by these state changes.

When that data changes, the HEEx template is re-evaluated, and the live view will keep track of any differences from one evaluation to the next. This allows the live view to only do the work of re-rendering portions of the template that have actually changed based on changes to the state held in socket assigns. In this way, HEEx templates are highly efficient

### Handle Change for the Product Edit

The `ProductLive.Index` live view will also support the Product Edit and Product New features by using the change management workflow to alter socket state with event handlers.

When we navigate to the Product Index route; `/products`, the LiveView lifecycle that kick-off first calls the `mount/3` lifecycle function, followed by `render/1`. If, however, we want to access and use the live action from socket assigns, we must do so in the `handle_params/3` lifecycle function. This callback, if it is implemented, is called right after the `mount/3`:

```bash
1. GET /product
2. mount/3
3. handle_params/3
4. render/1
4. browser renders html
```

#### Live Navigation with `live_patch/2`

```bash
<span><%= live_patch "Edit", to: Routes.product_index_path(@socket, :edit, product) %></span>
```

This generate an HTML link:

```bash
<a data-phx-link="patch" data-phx-link-state="push" href = "/products/1/edit">Edit</a>
```

If you clicking the link will change the URL in the browser bar, courtesy of a JavaScript feature called "push state navigation". But it won’t send a web request to reload the page. Instead, clicking this link will kick off LiveView’s change management workflow— the `handle_params/3` function will be invoked for the linked LiveView, followed by the `render/1` function. So, when you click the edit link on the product index template, you’ll see a modal pop up with the edit product form.

Navigating with `live_patch/2` causes that the request skips the call to `mount/3`. The handle_params/ 3 function will therefore be responsible for using these data points to update the socket with the correct information so that the template can render with the markup for editing a product.

### Establish Product Edit State

You can see that the generated `handle_params/3` function invokes a helper function, `apply_action/3` to do exactly that:

```bash
defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Catalog.get_product!(id))
  end
```

### LiveView Layers: The Modal Component

```bash
LiveView: index.html.heex => Modal dialog function: LiveHelpers.live_modal => Component: FormComponent
```
If the `ProductLive.Index` live view's state contains the :edit or :new live action, then the index template will invoke some code that renders the modal component.

```bash
<%= if @live_action in [:new, :edit] do %>
  <.modal return_to={Routes.product_index_path(@socket, :index)}>
    <.live_component
      module={PentoWeb.ProductLive.FormComponent}
      id={@product.id || :new}
      title={@page_title}
      action={@live_action}
      product={@product}
      return_to={Routes.product_index_path(@socket, :index)}
    />
  </.modal>
<% end %>
```

The `live_modal/2` function wraps up two concepts. The first is a CSS concept called a modal dialog. The generated CSS applied to the modal component will disallow interaction with the window underneath. The second concept is the component itself.

## Forms and Changesets

```bash
<.form
    let={f}
    for={@changeset}
    id="promo-form"
    phx-change="validate"
    phx-submit="save">

    <%= label f, :first_name %>
    <%= text_input f, :first_name %>
    <%= error_tag f, :first_name %>

    <%= label f, :email %>
    <%= text_input f, :email %>
    <%= error_tag f, :email %>

    <%= submit "Send Promo", phx_disable_with: "Sending promo..." %>
</.form>
```

The `<.form>` syntax is how you invoke a function component. A function component is a function, built with the help of the `Phoenix.Component behaviour`, that takes in an argument of an assigns map and returns a rendered HEEx template. The LiveView framework exposes this `form/1` function for us. It’s built on top of the `form_for/4` function and returns a form for the given changeset.

Our form implements two LiveView bindings, `phx-change` and `phx-submit`. The `phx-change` event will send a `"validate"` event each time the form changes.

```bash
def handle_event("validate", %{"recipient" => recipient_params}, %{assigns: %{recipient: recipient}} = socket) do
  changeset =
  recipient
  |> Promo.change_recipient(recipient_params)
  |> Map.put(:action, :validate)
  {
    :noreply,
    socket
    |> assign(:changeset, changeset)
  }
end
```

If the changeset’s action is empty, then no errors are set on the form object— even if the changeset is invalid and has a non-empty `:errors` value.

## LiveView Form Bindings

By default, binding `phx-submit` events causes three things to occur on the client:

* The form's inputs are set to "readonly"
* The submit button is desabled
* The "phx-submit-loading" CSS class is applied to the form

While the form is being submitted, no further form submissions can occur, since LiveView JavaScript disables the submit button. Our code uses the phx-disable-with binding to configure the text of a disabled submit button. The phx-debounce binding let’s you specify an integer timeout value or a value of blur. Use an integer to delay the event by the specified number of milliseconds. Use blur to have LiveView JavaScript emit the event when the user finishes and tabs away from the field.

