defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess")}
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
