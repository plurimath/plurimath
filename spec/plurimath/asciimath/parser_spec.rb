require "spec_helper"
require_relative "../../support/shared_parser_examples"

RSpec.describe Plurimath::Asciimath::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-14-iteration-1-example-1"
    it_behaves_like "shared parser constructor expectation", "asciimath-parser-14-iteration-2-example-1"
    it_behaves_like "shared parser constructor expectation", "asciimath-parser-14-iteration-3-example-1"
    it_behaves_like "shared parser constructor expectation", "asciimath-parser-14-iteration-4-example-1"
    it_behaves_like "shared parser constructor expectation", "asciimath-parser-14-iteration-5-example-1"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-31"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-47-example-1"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-70"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-87"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-104"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-145"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-164"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-176"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-195"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-213"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-240"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-261"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-283"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-313"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-353"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-391"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-412"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-432"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-455"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-482"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-508"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-532"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-553"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-575"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-596"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-610"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-624"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-638"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-652"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-666"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-680"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-694"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-711"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-732"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-759"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-773"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-787"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-801"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-815"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-831"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-847"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-861"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-875"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-886"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-900"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-924"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-953"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-980"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1007"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1024"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1038"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1052"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1066"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1084"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1109"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1158"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1185"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1206"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1227"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1248"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1269"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1301"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1341"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1381"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1397"

    context "when locale uses comma as the decimal separator" do
      around do |example|
        Plurimath.with_configuration do |config|
          config.locale = :fr
          example.run
        end
      end

      it_behaves_like "shared parser constructor expectation", "asciimath-parser-1416"

      it_behaves_like "shared parser constructor expectation", "asciimath-parser-1427"

      it_behaves_like "shared parser constructor expectation", "asciimath-parser-1446"

      it_behaves_like "shared parser constructor expectation", "asciimath-parser-1463"

      it_behaves_like "shared parser constructor expectation", "asciimath-parser-1476"

      it_behaves_like "shared parser constructor expectation", "asciimath-parser-1495"
    end

    context "when locale uses full stop as the decimal separator" do
      around do |example|
        Plurimath.with_configuration do |config|
          config.locale = :en
          example.run
        end
      end

      it_behaves_like "shared parser constructor expectation", "asciimath-parser-1536"
    end

    context "when locale uses Arabic decimal separator" do
      around do |example|
        Plurimath.with_configuration do |config|
          config.locale = :ar
          example.run
        end
      end

      it_behaves_like "shared parser constructor expectation", "asciimath-parser-1558"

      it_behaves_like "shared parser constructor expectation", "asciimath-parser-1569"
    end

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1583"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1595"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1607"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1620"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1847"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1919"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-1980"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-2006"

    it_behaves_like "shared parser constructor expectation", "asciimath-parser-2067"
  end
end
