defmodule Chandelier.Lights do
  # Map:
  # 12 24 22 27 17
  # 26  6 13  5 23
  @pins [26, 13, 23, 24, 27, 6, 5, 12, 22, 17]

  require Logger

  use GenServer

  alias Circuits.GPIO

  def start_link(type \\ Chandelier.GPIODummy, opts \\ []) do
    opts = Keyword.merge(opts, name: __MODULE__)
    GenServer.start_link(__MODULE__, [type], opts)
  end

  def server do
    Process.whereis(__MODULE__) ||
      raise "could not find process #{__MODULE__}. Have you started the application?"
  end

  def init([type]) do
    Logger.info "Starting Lights"
    lights = Enum.into(@pins, [], fn(pin) ->
      {:ok, gpio} = GPIO.open(pin, :output)
      gpio
    end)

    {:ok, %{lights: lights, type: type}}
  end

  def all_on() do
    GenServer.call(server(), :all_on)
  end

  def all_off() do
    GenServer.call(server(), :all_off)
  end

  def handle_call(:all_on, _from, state = %{lights: lights}) do
    Enum.map(lights, fn(light) -> on(light) end)
    {:reply, :ok, state}
  end
  def handle_call(:all_off, _from, state = %{lights: lights}) do
    Enum.map(lights, fn(light) -> off(light) end)
    {:reply, :ok, state}
  end
  def handle_call(request, from, state) do
    Logger.error "Received Call #{inspect request} - from #{inspect from} - state #{inspect state}"
    {:reply, :ok, state}
  end

  def handle_cast(request, from, state) do
    Logger.error "Received Cast #{inspect request} - from #{inspect from} - state #{inspect state}"
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.debug "Received Info msg - #{inspect msg} - state #{inspect state}"
    {:noreply, state}
  end

  def on(light) do
    Logger.debug "Turning on #{light |> inspect}"
    :ok = GPIO.write(light, 0)
  end

  def off(light) do
    Logger.debug "Turning off #{light |> inspect}"
    :ok = GPIO.write(light, 1)
  end
end
