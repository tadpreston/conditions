defmodule Conditions.CurrentObservation do
  @observation_url Application.get_env(:conditions, :obs_url)

  def fetch(station_id) do
    conditions_url(station_id)
    |> HTTPoison.get
    |> handle_response
  end

  def conditions_url(station_id) do
    "#{@observation_url}/#{station_id}.xml"
  end

  def handle_response({_, %{status_code: 200, body: body}}) do
    {
      :ok,
      body |> Conditions.XmlParser.parse_observations()
    }
  end
  def handle_response({_, %{status_code: status_code}}) do
    { :error, "Unable to fetch reading - #{status_code}" }
  end
end
