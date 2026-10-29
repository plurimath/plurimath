require "spec_helper"
require_relative "../../support/shared_parser_examples"

# These examples originate from https://github.com/metanorma/metanorma-standoc

RSpec.describe Plurimath::Asciimath::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-9"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-23"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-72"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-128"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-164"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-217"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-241"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-259"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-274"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-289"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-304"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-318"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-333"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-348"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-363"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-379"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-398"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-415"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-435"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-456"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-474"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-490"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-507"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-526"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-553"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-573"

    it_behaves_like "shared parser constructor expectation", "asciimath-metanorma-examples-594"
  end
end
