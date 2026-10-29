require "spec_helper"
require_relative "../../support/shared_parser_examples"

RSpec.describe Plurimath::Latex::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-7"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-25"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-51"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-65"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-98"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-178"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-215"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-264"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-304"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-329"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-378"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-427"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-572"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-598"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-624"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-692"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-760"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-829"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-847"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-893"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-919"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-935"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-951"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-964"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-983"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1002"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1089"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1190"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1204"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1218"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1241"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1280"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1292"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1318"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1343"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1372"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1406"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1440"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1455"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1485"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1502"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1532"

    it_behaves_like "shared parser constructor expectation", "latex-latexmath-aggregator-1938"
  end
end
