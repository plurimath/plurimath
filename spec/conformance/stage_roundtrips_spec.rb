# frozen_string_literal: true

require "spec_helper"
require "tmpdir"
require_relative "../../scripts/replay_stage_roundtrips"

# Replays the plurimath-testsuite roundtrip generation pinned in
# spec/fixtures/roundtrip-pin.yml (scripts/replay_stage_roundtrips.rb).
module StageRoundtripsSpecData
  module_function

  # Computed once per process, not once per example and XML engine pass.
  def result
    @result ||= ReplayStageRoundtrips.run
  end

  def pin
    YAML.safe_load_file(ReplayStageRoundtrips::DEFAULT_PIN)
  end
end

RSpec.describe ReplayStageRoundtrips do
  def pin_file(dir, changes)
    path = File.join(dir, "pin.yml")
    File.write(path, YAML.dump(StageRoundtripsSpecData.pin.merge(changes)))
    path
  end

  it "replays every case of the pinned generation without a difference" do
    result = StageRoundtripsSpecData.result

    expect(result["cases"]).to eq(46)
    expect(result["differing"]).to eq([])
  end

  it "replays lossless, lossy and refused cases" do
    result = StageRoundtripsSpecData.result

    expect(result["lossless"]).to be_positive
    expect(result["lossy"]).to be_positive
    expect(result["refused"]).to be_positive
  end

  it "rejects a pin with a wrong digest" do
    Dir.mktmpdir do |dir|
      pin = pin_file(dir, "snapshot_digest" => "sha256:#{'0' * 64}")

      expect { described_class.run(pin: pin) }
        .to raise_error(described_class::Error, /digest/)
    end
  end

  it "rejects a pin with a generation the ledger does not have" do
    Dir.mktmpdir do |dir|
      pin = pin_file(dir, "generation" => 99)

      expect { described_class.run(pin: pin) }
        .to raise_error(described_class::Error, /no generation 99/)
    end
  end

  it "rejects a pin whose commit is not the checkout's" do
    Dir.mktmpdir do |dir|
      pin = pin_file(dir, "commit" => "0" * 40)

      expect { described_class.run(pin: pin) }
        .to raise_error(described_class::Error, /HEAD/)
    end
  end

  it "rejects a --generation other than the pinned one" do
    expect { described_class.run(generation: 2) }
      .to raise_error(described_class::Error, /not the pinned 1/)
  end
end
