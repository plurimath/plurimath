require "spec_helper"
require_relative "../../support/shared_parser_examples"

# These examples originate from https://github.com/asciidoctor/asciimath

RSpec.describe Plurimath::Asciimath::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-9"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-43"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-86"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-110"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-145"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-192"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-248"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-285"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-348"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-392"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-414"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-450"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-496"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-524"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-539"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-582"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-611"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-633"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-659"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-683"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-732"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-770"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-842"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-885"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-901"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-932"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-949"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-960"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-984"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1052"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1100"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1132"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1154"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1168"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1185"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1202"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1219"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1241"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1257"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1280"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1304"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1349"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1376"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1388"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1404"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1415"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1430"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1457"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1483"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1498"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1516"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1560"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1578"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1595"

    it_behaves_like "shared parser constructor expectation", "asciimath-asciidoctor-examples-1609"
  end
end
