defmodule WimsWeb.Socket.Raw do
  defmacro __using__(opts) do
    quote do
      ## User API

      import Phoenix.Socket
      @behaviour Phoenix.Socket
      @before_compile Phoenix.Socket
      Module.register_attribute(__MODULE__, :phoenix_channels, accumulate: true)
      @phoenix_socket_options unquote(opts)

      ## Callbacks

      @behaviour Phoenix.Socket.Transport

      @doc false
      def child_spec(opts) do
        IO.inspect("----- child spec")
        Phoenix.Socket.__child_spec__(__MODULE__, opts, @phoenix_socket_options)
      end

      @doc false
      def connect(map) do
        IO.inspect("----- connect")
        Phoenix.Socket.__connect__(__MODULE__, map, @phoenix_socket_options)
      end

      @doc false
      def init(state) do
        IO.inspect("--- init")
        Phoenix.Socket.__init__(state)
      end

      @doc false
      def handle_in(message, state) do
        IO.inspect("--- handle in")
        Phoenix.Socket.__in__(message, state)
      end

      @doc false
      def handle_info(message, state) do
        IO.inspect("--- handle info")
        Phoenix.Socket.__info__(message, state)
      end

      @doc false
      def terminate(reason, state) do
        IO.inspect("--- terminate")
        Phoenix.Socket.__terminate__(reason, state)
      end
    end
  end


  #  -----------------------------------------

  # def child_spec(opts) do
  #   IO.inspect("--- child spec")
  #   Phoenix.Socket.__child_spec__(__MODULE__, otps, )
  # end

  # def connect(map) do

  # end

  # def init(state) do

  # end

  # def handle_in({text, _opts}, state) do

  # end

  # def handle_info(_, state) do
  #   {:ok, state}
  # end

  # def terminate(_reason, _state) do
  #   :ok
  # end
end
