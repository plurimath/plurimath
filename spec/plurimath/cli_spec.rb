require "spec_helper"
require_relative "../support/shared_cli_examples"
require "plurimath/cli"

RSpec.describe Plurimath::Cli do
  describe ".convert" do
    context "contains no argument" do
      let(:options) { ["convert"] }

      it "matches exit status" do
        expect do
          described_class.start(options)
        end.to raise_error(SystemExit) { |error| expect(error.status).to eq(1) }
      end
    end

    it_behaves_like "shared CLI conversion", "cli-convert-1"

    it_behaves_like "shared CLI conversion", "cli-convert-2"

    it_behaves_like "shared CLI conversion", "cli-convert-3"
  end
end
