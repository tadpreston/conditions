defmodule Conditions.XmlParser do
  require Record
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText,    Record.extract(:xmlText,    from_lib: "xmerl/include/xmerl.hrl")

  @root_path "/current_observation"
  @nodes ~w(location station_id observation_time weather temperature_string relative_humidity)

  def parse_observations(xml_doc) do
    xml_doc
    |> scan_text
    |> parse_xml
  end

  def scan_text(xml_doc) do
    :xmerl_scan.string(String.to_charlist(xml_doc))
  end

  def parse_xml({xml, _}) do
    for node <- @nodes do
      [element] = :xmerl_xpath.string(String.to_charlist("#{@root_path}/#{node}"), xml)
      [text] =    xmlElement(element, :content)
      value  =    xmlText(text, :value)
      { node, value }
    end
  end
end
