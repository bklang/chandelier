defmodule ChandelierWeb.SwitchController do
  use ChandelierWeb, :controller
  require Logger
  alias Chandelier.Lights

  def switch(conn, _params = %{"light" => light, "direction" => direction})  do
    Lights.switch(normalize_light(light), normalize_direction(direction))

    conn
    |> send_resp(:no_content, "")
  end

  def switch_all(conn, _params = %{"direction" => direction}) do
    direction
    |> normalize_direction
    |> Lights.switch_all

    conn
    |> send_resp(:no_content, "")
  end

  def normalize_light(light) when is_integer(light), do: light
  def normalize_light(light), do: String.to_integer(light)

  def normalize_direction(direction) do 
    cond do
      direction in [1, "1", "on", "true", true] ->
        true
      true -> # else
        false
    end
  end
end
