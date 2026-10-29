# frozen_string_literal: true

require "spec_helper"
require_relative "../support/shared_corpus"

RSpec.describe SharedCorpus do
  it "preserves the portable tree projection for both parser slice types" do
    tree = {
      latex: Parsanol::Slice.new(0, "x", "x"),
      asciimath: [Parslet::Source.new("y").consume(1)],
    }

    expect(described_class.serialize_tree(tree, "example"))
      .to eq("latex" => "x", "asciimath" => ["y"])
  end

  it "continues rejecting unrecognized tree values" do
    expect do
      described_class.serialize_tree(Object.new, "unknown")
    end.to raise_error(CorpusGenerator::Error, /cannot serialize/)
  end

  it "converts a native byte rejection position to a character index" do
    source = Parsanol::Source.new("αx")
    cause = Parsanol::Cause.new("rejected", source, 2)

    expect(described_class.failure_position(cause)).to eq(1)
  end
end
