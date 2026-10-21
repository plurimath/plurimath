require "spec_helper"
require_relative "../../../support/shared_parser_examples"

# These examples originate from https://github.com/metanorma/mn-samples-nist

RSpec.describe Plurimath::Asciimath::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-nist-9"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-nist-20"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-nist-33"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-nist-48"
  end
end
