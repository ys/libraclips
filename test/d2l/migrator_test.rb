require 'test_helper'

class D2L::MigratorTest < Minitest::Unit::TestCase

  def outdated
    [D2L::Measurement.new(dataclip_reference: 'dataclip', librato_base_name: 'default')]
  end

  def test_migrates_all_outdated
    measurements = Minitest::Mock.new
    measurements.expect :outdated, outdated
    measurements.expect :just_run!, nil, [outdated.first.id]
    metrics = Minitest::Mock.new
    transformer = Minitest::Mock.new
    transformer.expect :call, metrics, outdated
    librato_client = Minitest::Mock.new
    librato_client.expect :submit, nil, [metrics]
    migrator = D2L::Migrator.new
    migrator.measurements = measurements
    migrator.librato_client = librato_client
    migrator.transformer = transformer
    migrator.migrate_outdated_measurements
    librato_client.verify
    measurements.verify
  end
end
