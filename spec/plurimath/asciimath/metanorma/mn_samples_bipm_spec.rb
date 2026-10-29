require "spec_helper"
require_relative "../../../support/shared_parser_examples"

# These examples originate from https://github.com/metanorma/mn-samples-itu

RSpec.describe Plurimath::Asciimath::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-9"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-46"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-256"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-277"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-438"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-463"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-506"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-560"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-666"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-724"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-759"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-816"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-879"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-958"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-1302"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-bipm-1347"
  end
end
