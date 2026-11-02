# frozen_string_literal: true

require "spec_helper"
require "tmpdir"
require_relative "../support/shared_corpus"

RSpec.describe SharedCorpus do
  it "fails when the corpus directory is missing" do
    Dir.mktmpdir("plurimath-corpus-") do |directory|
      expect { described_class.load(corpus_root: File.join(directory, "missing")) }
        .to raise_error(SharedCorpus::Error, /no corpus directory/)
    end
  end

  it "fails when no corpus files are present" do
    Dir.mktmpdir("plurimath-corpus-") do |directory|
      expect { described_class.load(corpus_root: directory) }
        .to raise_error(SharedCorpus::Error, /no corpus files/)
    end
  end

  it "rejects a payload declaring an unknown schema" do
    Dir.mktmpdir("plurimath-corpus-") do |directory|
      Dir.mkdir(File.join(directory, "asciimath"))
      File.write(File.join(directory, "asciimath", "unknown.yaml"),
                 "schema: plurimath-corpus/asciimath/999\n")
      expect { described_class.load(corpus_root: directory) }
        .to raise_error(SharedCorpus::Error, /no schema|unknown schema|no known schema/)
    end
  end
end
