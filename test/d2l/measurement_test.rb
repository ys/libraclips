require 'test_helper'

class D2L::MeasurementTest < Minitest::Unit::TestCase

  def valid_measurement
    D2L::Measurement.new(dataclip_reference: 'ref',
                         librato_base_name: 'default',
                         run_interval: 50)
  end

  def test_validations
    assert valid_measurement.valid?
  end

  def test_dataclip_reference_presence
    no_dataclip = valid_measurement
    no_dataclip.dataclip_reference = nil
    refute no_dataclip.valid?
    assert_includes no_dataclip.errors, :dataclip_reference
  end

  def test_librato_base_name_presence
    no_librato = valid_measurement
    no_librato.librato_base_name = nil
    refute no_librato.valid?
    assert_includes no_dataclip.errors, :librato_base_name
  end

  def test_librato_base_name_presence
    no_run_interval = valid_measurement
    no_run_interval.run_interval = nil
    # We set a default value in before_validation
    assert no_run_interval.valid?
  end

  def test_dataclip_reference_uniqueness
    DB.transaction(rollback: :always) do
      valid_measurement.save
      duplicate_dataclip_reference = valid_measurement
      refute duplicate_dataclip_reference.valid?
      # I do not understand why here it is an array...
      assert_includes duplicate_dataclip_reference.errors, [:dataclip_reference]
    end
  end

  def test_to_json
    json = "{\"dataclip_reference\":\"ref\",\"librato_base_name\":\"default\",\"run_interval\":50}"
    assert_equal valid_measurement.to_json, json
  end

  def test_outdated
    DB.transaction(rollback: :always) do
      outdated = D2L::Measurement.create(dataclip_reference: 'down',
                                         librato_base_name: 'd')
      up_to_date = D2L::Measurement.create(dataclip_reference: 'up',
                                           librato_base_name: 'd',
                                           run_at: Time.now)
      assert_includes D2L::Measurement.outdated, outdated
      refute_includes D2L::Measurement.outdated, up_to_date
    end
  end

  def test_just_run!
    DB.transaction(rollback: :always) do
      now = Time.now
      Time.stub :now, now do
        m = D2L::Measurement.create(dataclip_reference: 'down',
                                    librato_base_name: 'd')
        D2L::Measurement.just_run!(m.id)
        assert_equal m.reload.run_at, Time.now
      end
    end
  end

  def test_has_dataclip?
    DB.transaction(rollback: :always) do
      m = D2L::Measurement.create(dataclip_reference: 'down',
                                  librato_base_name: 'd')
      assert D2L::Measurement.has_dataclip?(m.dataclip_reference)
      refute D2L::Measurement.has_dataclip?('fake_id')
    end
  end
end
