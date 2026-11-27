# frozen_string_literal: true

require "spec_helper"
require_relative "../../scripts/replay_stage_roundtrips"
require_relative "../support/shared_corpus"

# HTML has no standalone stage gem. Its facade is the consumer of the
# sealed HTML rejection generation, including preprocessing and offsets.
module HtmlStageSpecData
  PIN = File.expand_path("../fixtures/html-pin.yml", __dir__)

  module_function

  def rows
    pin = ReplayStageRoundtrips.load_pin(PIN, language: "html")
    dir, entry = ReplayStageRoundtrips.verify(SharedCorpus::ROOT, pin, language: "html")
    rows = Dir.glob(File.join(dir, "payloads", "*.yaml")).flat_map do |path|
      payload = YAML.safe_load_file(path, aliases: false)
      unless payload.fetch("schema") == "plurimath-corpus/rejections/1" &&
          payload.fetch("input_format") == "html"
        raise SharedCorpus::Error, "#{path}: not an HTML rejection payload"
      end

      payload.fetch("cases")
    end
    unless rows.size.positive? && rows.size == entry.fetch("rows") &&
        rows.all? { |row| row.fetch("input_format") == "html" }
      raise SharedCorpus::Error, "HTML stage rows do not match the pinned ledger"
    end

    rows
  end
end

RSpec.describe "pinned HTML stage conformance", :shared_corpus do # rubocop:disable RSpec/DescribeClass
  it "rejects a pin for a different stage" do
    expect { ReplayStageRoundtrips.load_pin(HtmlStageSpecData::PIN) }
      .to raise_error(ReplayStageRoundtrips::Error, /language is not roundtrip/)
  end

  HtmlStageSpecData.rows.each do |row|
    it "replays #{row.fetch('id')}" do
      format = CorpusGenerator::FORMATS.find { |entry| entry.name == "html" }
      aggregate_failures(row.fetch("id")) do
        expect(CorpusGenerator.preprocessed_text(format, row.fetch("input")))
          .to eq(row.fetch("preprocessed"))
        expect { Plurimath::Math.parse(row.fetch("input"), :html) }
          .to raise_error(Plurimath::Math::ParseError)
        expect(SharedCorpus.rejection_error(format, row.fetch("input")))
          .to eq(row.fetch("error"))
      end
    end
  end
end
