require 'scrolls'
require_relative 'dataclips'
require_relative 'transform_functions'
module D2L
class Transformer
  attr_writer :dataclips_client, :transform_function

  def call(measurement)
    @measurement = measurement
    dataclip = fetch_dataclip
    return if @measurement.nil? || dataclip.empty?
    transform_function(dataclip).call(dataclip, measurement)
  end

  private

  attr_reader :measurement

  def transform_function(dataclip)
    @transform_function || TransformFunctions.find_for(dataclip)
  end

  def fetch_dataclip
    dataclips_client.fetch(measurement.dataclip_reference)
  end

  def dataclips_client
    @dataclips_client || Dataclips::Client.new
  end
end
end
