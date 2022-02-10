defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, session, socket) do
    IO.inspect session
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Make a guess",
        session_id: session["live_socket_id"]
        )
      }
  end

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
    <pre>
    </pre>
    </h2>
    '''
  end

  def handle_event("guess", %{"number" => guess} = _data, socket) do
    message = "Your guess: #{guess} Wrong"
    score = socket.assigns.score - 1
    {
      :noreply,
      assign(socket, score: score, message: message)
    }
  end


end
