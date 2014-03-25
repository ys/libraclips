require 'scrolls'
require_relative 'dataclips'
require_relative 'transform_functions'
module D2L
class Transformer
  def initialize(dataclip_ref, librato_base_name = nil)
    @dataclip_ref = dataclip_ref
    @librato_base_name = librato_base_name
  end

  def call
    return if dataclip.empty?
    transform_function.call(dataclip, librato_base_name: @librato_base_name)
  end

  def transform_function
    @transform_function ||= TransformFunctions.find_for(dataclip)
  end

  def dataclip
    @dataclip ||= dataclips_client.fetch(@dataclip_ref)
  end

  def dataclips_client
    @dataclips_client ||= Dataclips::Client.new
  end
end
end
