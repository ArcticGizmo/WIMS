defmodule WimsWeb.Socket.TrackerOne do
  use WimsWeb.TCP.Raw

  require Logger

  # @start ~r/$FRRET,{imei},_StartTracking
  @start ~r/(\$FRRET,)(?<imei>[A-Za-z0-9]+)(,_StartTracking)(.*)/

  def handle_msg(msg, transport) do
    response =
      case Regex.named_captures(@start, msg) do
        %{"imei" => imei} ->
          Logger.info("[TrackerOne] Got start for imie: #{imei}")
          "valid message"

        nil ->
          Logger.info("[TrackerOne] invalid message")
          "invalid message"
      end

    {:reply, response, transport}
  end

  def on_close(_reason) do
    Logger.error("[TrackerOne] Socket closed")
  end
end
