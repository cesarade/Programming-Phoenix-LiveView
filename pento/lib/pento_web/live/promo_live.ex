defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view
  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign_recipient
      |> assign_changeset
  }
  end

  def assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  def assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
    socket
    |> assign(:changeset, Promo.change_recipient(recipient))
  end

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

  def handle_event("save", %{"recipient" => recipient_params},  %{assigns: %{recipient: recipient}} = socket)  do
    # :timer.sleep(4000)
    {:ok, result} = Promo.send_promo(recipient, recipient_params)

    changeset =
    result
    |> Promo.change_recipient(recipient_params)
    |> Map.put(:action, :save)

    {
      :noreply,
      socket
      |> assign(:changeset, changeset)
    }
  end

end
