# frozen_string_literal: true

require "spec_helper"
require "digest"
require "fileutils"
require "open3"
require "tmpdir"
require_relative "../../scripts/replay_asciimath_corpus"

# Replays the pinned plurimath-testsuite AsciiMath corpus
# (scripts/replay_asciimath_corpus.rb). The end-to-end examples need a
# testsuite checkout at the pinned commit, named by PLURIMATH_TESTSUITE; the
# in-process controls below run without it.
# Subprocess runs of the replay CLI, each made once per process rather than
# once per example and XML engine pass.
module AsciimathCorpusReplaySpecRuns
  SCRIPT = File.expand_path("../../scripts/replay_asciimath_corpus.rb", __dir__)

  module_function

  def results(checkout)
    @results ||= {
      pinned: run_script("--testsuite-checkout", checkout),
      no_group: run_script("--testsuite-checkout", checkout, "--group", "no-such-group"),
    }.merge(control_runs(checkout))
  end

  def run_script(*args)
    out, status = Open3.capture2e({ "PLURIMATH_OGA" => nil }, Gem.ruby, SCRIPT, *args)
    [out, status.exitstatus]
  end

  def rewrite_payload(corpus, rel)
    path = File.join(corpus, rel)
    old_bytes = File.binread(path)
    new_bytes = yield(old_bytes)
    File.binwrite(path, new_bytes)
    [Digest::SHA256.hexdigest(old_bytes), old_bytes.bytesize,
     Digest::SHA256.hexdigest(new_bytes), new_bytes.bytesize]
  end

  # A copy whose colour payload carries one wrong expectation: first with the
  # pinned provenance (an integrity failure), then with provenance rewritten
  # to match the edited bytes (a replay mismatch).
  def control_runs(checkout)
    Dir.mktmpdir("replay-control") do |dir|
      FileUtils.cp_r(File.join(checkout, "corpus"), dir)
      corpus = File.join(dir, "corpus")
      rel = "asciimath/colour.yaml"
      old_sha, old_size, new_sha, new_size = rewrite_payload(corpus, rel) do |bytes|
        bytes.sub("    asciimath: color(red)(x)\n", "    asciimath: color(red)(y)\n")
      end
      tampered = run_script("--testsuite-checkout", dir, "--group", "colour")

      provenance = File.join(corpus, "provenance.yaml")
      text = File.binread(provenance)
      File.binwrite(provenance, text.sub("- path: #{rel}\n  sha256: #{old_sha}\n  bytes: #{old_size}\n",
                                         "- path: #{rel}\n  sha256: #{new_sha}\n  bytes: #{new_size}\n"))
      wrong = run_script("--testsuite-checkout", dir, "--group", "colour",
                         "--expected-provenance-sha256", Digest::SHA256.file(provenance).hexdigest)
      { tampered: tampered, wrong_expectation: wrong }
    end
  end
end

RSpec.describe AsciimathCorpusReplay do
  def replay(payload, group = payload["group"])
    report = AsciimathCorpusReplay::Report.new
    described_class.replay_payload(payload, group, report)
    report
  end

  def case_payload(schema: "plurimath-corpus/asciimath/1", targets: %w[asciimath], expected: { "asciimath" => "x" })
    {
      "schema" => schema,
      "group" => "control",
      "description" => "control",
      "input_format" => "asciimath",
      "targets" => targets,
      "cases" => [{
        "id" => "control-x",
        "input" => "x",
        "input_format" => "asciimath",
        "preprocessed" => "x",
        "expected" => expected,
        "parse_tree" => {},
        "model" => {},
      }],
    }
  end

  describe "failure controls on in-memory payloads" do
    it "passes a correct expectation" do
      report = replay(case_payload)

      expect(report.failures).to be_empty
      expect(report.outcomes["plurimath-corpus/asciimath/1"]["output_match"]).to eq(1)
    end

    it "records a mismatch for a wrong expected output" do
      report = replay(case_payload(expected: { "asciimath" => "y" }))

      expect(report.failures.join).to include("control/control-x.asciimath: output differs")
    end

    it "records a mismatch when an expected renderer error does not occur" do
      report = replay(case_payload(schema: "plurimath-corpus/asciimath/2",
                                   expected: { "asciimath" => { "error" => { "category" => "parse_error" } } }))

      expect(report.failures.join).to include("expected [:error")
    end

    it "rejects an unknown schema" do
      expect { replay(case_payload(schema: "plurimath-corpus/asciimath/99")) }
        .to raise_error(AsciimathCorpusReplay::Error, /unknown schema/)
    end

    it "rejects a declared target without an expectation" do
      expect { replay(case_payload(targets: %w[asciimath latex])) }
        .to raise_error(AsciimathCorpusReplay::Error, /expectations missing for \["latex"\]/)
    end

    it "rejects an unknown call method" do
      payload = case_payload(schema: "plurimath-corpus/calls/1",
                             expected: { "asciimath" => { "output" => "x" } })
      payload["cases"].first["call"] = { "method" => "display_style", "args" => {} }

      expect { replay(payload) }
        .to raise_error(AsciimathCorpusReplay::Error, /unknown call method/)
    end

    it "records a mismatch when an expected rejection is accepted" do
      payload = {
        "schema" => "plurimath-corpus/rejections/1",
        "group" => "control",
        "description" => "control",
        "input_format" => "asciimath",
        "cases" => [{ "id" => "accepted", "input" => "x", "input_format" => "asciimath",
                      "preprocessed" => "x", "error" => { "category" => "parse_error", "index" => 0 } }],
      }

      expect(replay(payload).failures.join).to include("input was ACCEPTED")
    end

    it "rejects a payload with no cases" do
      payload = case_payload
      payload["cases"] = []

      expect { replay(payload) }.to raise_error(AsciimathCorpusReplay::Error, /no cases/)
    end
  end

  describe "the pinned testsuite corpus" do
    let(:checkout) { ENV.fetch("PLURIMATH_TESTSUITE", nil) }
    let(:runs) { AsciimathCorpusReplaySpecRuns.results(checkout) }

    before do
      skip "PLURIMATH_TESTSUITE is not set to a plurimath-testsuite checkout" unless checkout
    end

    it "replays every AsciiMath case without a mismatch" do
      out, status = runs[:pinned]

      expect(status).to eq(0), out
      expect(out).to include("total: 27 payloads, 173 cases, 0 failures")
      expect(out).to match(%r{plurimath-corpus/rejections/1 +1 +13 })
      expect(out).to match(%r{plurimath-corpus/calls/1 +7 +66 })
      expect(out).to match(%r{plurimath-corpus/asciimath/2 +1 +4 .*render_error_match=4})
      expect(out).to match(%r{plurimath-corpus/calls/2 +1 +2 })
    end

    it "fails nonzero when a payload no longer matches its provenance checksum" do
      out, status = runs[:tampered]

      expect(status).to eq(2)
      expect(out).to include("payload asciimath/colour.yaml")
    end

    it "fails nonzero on a wrong expectation with consistent provenance" do
      out, status = runs[:wrong_expectation]

      expect(status).to eq(1)
      expect(out).to include("MISMATCH colour/colour-named.asciimath: output differs")
    end

    it "fails nonzero when the selection matches no payload" do
      out, status = runs[:no_group]

      expect(status).to eq(2)
      expect(out).to include("unknown --group no-such-group")
    end
  end
end
