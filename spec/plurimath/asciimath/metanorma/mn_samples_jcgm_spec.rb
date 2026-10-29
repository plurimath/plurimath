require "spec_helper"
require_relative "../../../support/shared_parser_examples"

# These examples originate from https://github.com/metanorma/mn-samples-jcgm

RSpec.describe Plurimath::Asciimath::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-9"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-325"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-485"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-555"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-631"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-701"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-768"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-792"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-863"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-923"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-965"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-1001"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-1056"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-1187"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-1250"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-1280"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-1314"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-1399"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-1710"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-1761"

    it_behaves_like "shared parser constructor expectation", "asciimath-mn-samples-jcgm-1788"
  end
end
