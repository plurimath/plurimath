require "spec_helper"
require_relative "../../support/shared_parser_examples"

RSpec.describe Plurimath::Latex::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    it_behaves_like "shared parser constructor expectation", "latex-metanorma-examples-7"

    it_behaves_like "shared parser constructor expectation", "latex-metanorma-examples-22"

    it_behaves_like "shared parser constructor expectation", "latex-metanorma-examples-44"

    it_behaves_like "shared parser constructor expectation", "latex-metanorma-examples-66"

    it_behaves_like "shared parser constructor expectation", "latex-metanorma-examples-88"

    it_behaves_like "shared parser constructor expectation", "latex-metanorma-examples-107"

    it_behaves_like "shared parser constructor expectation", "latex-metanorma-examples-125"

    it_behaves_like "shared parser constructor expectation", "latex-metanorma-examples-146"

    # repo: https://github.com/metanorma/mn-samples-itu/sources/STL-manual/en.adoc

    it_behaves_like "shared parser constructor expectation", "latex-metanorma-examples-166"
  end
end
