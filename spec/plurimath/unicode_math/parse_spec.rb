require "spec_helper"

RSpec.describe Plurimath::UnicodeMath::Parse do
  describe "#number" do
    subject(:number) { described_class.new.number.parse(string) }

    context "when locale decimal marker is encoded before parsing" do
      around do |example|
        Plurimath.with_configuration do |config|
          config.locale = :ar
          example.run
        end
      end

      let(:string) { "1&#x66b;2" }

      it "parses the encoded configured marker as part of the number" do
        decimal_number = number[:decimal_number]

        expect(decimal_number[:whole][:number]).to eq("1")
        expect(decimal_number[:decimal]).to eq("&#x66b;")
        expect(decimal_number[:fractional][:number]).to eq("2")
      end
    end
  end
end
