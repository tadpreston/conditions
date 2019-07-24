defmodule Conditions.CLI do
  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean],
                             aliases:  [h:    :help])
    |> elem(1)
    |> args_to_internal()
  end

  def args_to_internal([station_id]), do: { station_id }
  def args_to_internal(_), do: :help

  def process(:help) do
    IO.puts """
    usage: conditions <station_id>
    """
    System.halt(0)
  end
  def process({ station_id }) do
    station_id
    |> Conditions.CurrentObservation.fetch
    |> decode_response
    |> print_table
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, message}) do
    IO.puts "Error fetching from NOAA: #{message}"
    System.halt(2)
  end

  def print_table(body) do

  end
end
