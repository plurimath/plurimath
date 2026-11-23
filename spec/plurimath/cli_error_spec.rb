# frozen_string_literal: true

require "spec_helper"
require "plurimath/cli"

RSpec.describe Plurimath::Cli, engine_loop: :always do
  describe "parse error diagnostics" do
    let(:input) { '{\sin{d}' }
    let(:message) do
      begin
        Plurimath::Math.parse(input, :latex)
      rescue Plurimath::Math::ParseError => error
        error.message
      end
    end

    %w[convert render].each do |command|
      it "reports only the parse error and exits 1 through #{command}" do
        expected = message
        expect(expected).to include("Failed to parse")
        expect do
          expect do
            described_class.start([command, "-i", input, "-f", "latex"])
          end.to raise_error(SystemExit) { |error| expect(error.status).to eq(1) }
        end.to output("#{expected.chomp}\n").to_stderr
      end
    end

    it "still writes valid conversion output" do
      expect do
        described_class.start(["convert", "-i", "x", "-f", "latex", "-t", "latex"])
      end.to output("x\n").to_stdout
    end
  end
end
