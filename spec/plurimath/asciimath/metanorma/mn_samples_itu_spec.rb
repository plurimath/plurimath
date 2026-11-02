require "spec_helper"
require_relative "../../../support/shared_parser_examples"

# These examples originate from https://github.com/metanorma/mn-samples-itu

RSpec.describe Plurimath::Asciimath::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-itu-9"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-itu-70"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-itu-172"
  end
end
