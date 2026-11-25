# frozen_string_literal: true

# A replay still writes and checks every target of every case. Only identical
# successful parser inputs within an example share work; refusals run each time.
# Snapshot each result so rendering or editing one Formula cannot affect another.
module RoundtripParseCache
  def memoize_roundtrip_parses
    snapshots = {}
    [RoundtripCases, ReplayStageRoundtrips].each do |reader|
      allow(reader).to receive(:parse).and_wrap_original do |original, input, language, options|
        key = [Plurimath.xml_engine, Mml::V4::Configuration.adapter,
               input, language.to_sym, options]
        snapshot = snapshots[key] ||= Marshal.dump(original.call(input, language, options))
        Marshal.load(snapshot)
      end
    end
  end
end
