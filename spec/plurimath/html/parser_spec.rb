require "spec_helper"
require_relative "../../support/shared_parser_examples"

RSpec.describe Plurimath::Html::Parser do
  describe ".parse" do
    subject(:formula) do
      described_class.new(parser_input).parse
    end

    let(:parser_input) { string.gsub(/\s/, "") }

    it_behaves_like "shared parser constructor expectation", "html-parser-11"

    it_behaves_like "shared parser constructor expectation", "html-parser-22"

    context "when locale uses comma as the decimal separator" do
      around do |example|
        Plurimath.with_configuration do |config|
          config.locale = :fr
          example.run
        end
      end

      it_behaves_like "shared parser constructor expectation", "html-parser-41"

      it_behaves_like "shared parser constructor expectation", "html-parser-52"

      it_behaves_like "shared parser constructor expectation", "html-parser-65"
    end

    context "when locale uses full stop as the decimal separator" do
      around do |example|
        Plurimath.with_configuration do |config|
          config.locale = :en
          example.run
        end
      end

      it_behaves_like "shared parser constructor expectation", "html-parser-85"
    end

    context "when locale uses Arabic decimal separator" do
      around do |example|
        Plurimath.with_configuration do |config|
          config.locale = :ar
          example.run
        end
      end

      it_behaves_like "shared parser constructor expectation", "html-parser-107"

      it_behaves_like "shared parser constructor expectation", "html-parser-118"
    end

    it_behaves_like "shared parser constructor expectation", "html-parser-130"

    it_behaves_like "shared parser constructor expectation", "html-parser-149"

    it_behaves_like "shared parser constructor expectation", "html-parser-163"

    it_behaves_like "shared parser constructor expectation", "html-parser-182"

    it_behaves_like "shared parser constructor expectation", "html-parser-206"

    it_behaves_like "shared parser constructor expectation", "html-parser-223"

    it_behaves_like "shared parser constructor expectation", "html-parser-243"

    it_behaves_like "shared parser constructor expectation", "html-parser-263"

    it_behaves_like "shared parser constructor expectation", "html-parser-309"

    it_behaves_like "shared parser constructor expectation", "html-parser-325"

    it_behaves_like "shared parser constructor expectation", "html-parser-339"

    it_behaves_like "shared parser constructor expectation", "html-parser-353"

    it_behaves_like "shared parser constructor expectation", "html-parser-367"

    it_behaves_like "shared parser constructor expectation", "html-parser-381"

    it_behaves_like "shared parser constructor expectation", "html-parser-395"

    it_behaves_like "shared parser constructor expectation", "html-parser-413"

    it_behaves_like "shared parser constructor expectation", "html-parser-431"

    it_behaves_like "shared parser constructor expectation", "html-parser-449"

    it_behaves_like "shared parser constructor expectation", "html-parser-466"

    it_behaves_like "shared parser constructor expectation", "html-parser-483"

    it_behaves_like "shared parser constructor expectation", "html-parser-500"

    it_behaves_like "shared parser constructor expectation", "html-parser-517"

    it_behaves_like "shared parser constructor expectation", "html-parser-532"

    it_behaves_like "shared parser constructor expectation", "html-parser-557"

    it_behaves_like "shared parser constructor expectation", "html-parser-573"

    it_behaves_like "shared parser constructor expectation", "html-parser-594"

    it_behaves_like "shared parser constructor expectation", "html-parser-616"

    it_behaves_like "shared parser constructor expectation", "html-parser-636"

    it_behaves_like "shared parser constructor expectation", "html-parser-654"

    it_behaves_like "shared parser constructor expectation", "html-parser-665"

    it_behaves_like "shared parser constructor expectation", "html-parser-676"

    it_behaves_like "shared parser constructor expectation", "html-parser-689"

    it_behaves_like "shared parser constructor expectation", "html-parser-702"

    it_behaves_like "shared parser constructor expectation", "html-parser-724"

    it_behaves_like "shared parser constructor expectation", "html-parser-737"

    it_behaves_like "shared parser constructor expectation", "html-parser-762"

    it_behaves_like "shared parser constructor expectation", "html-parser-787"

    it_behaves_like "shared parser constructor expectation", "html-parser-836"

    it_behaves_like "shared parser constructor expectation", "html-parser-887"

    it_behaves_like "shared parser constructor expectation", "html-parser-911"

    it_behaves_like "shared parser constructor expectation", "html-parser-930"

    it_behaves_like "shared parser constructor expectation", "html-parser-944"

    it_behaves_like "shared parser constructor expectation", "html-parser-963"

    it_behaves_like "shared parser constructor expectation", "html-parser-981"

    it_behaves_like "shared parser constructor expectation", "html-parser-995"

    it_behaves_like "shared parser constructor expectation", "html-parser-1009"

    it_behaves_like "shared parser constructor expectation", "html-parser-1024"

    it_behaves_like "shared parser constructor expectation", "html-parser-1045"

    it_behaves_like "shared parser constructor expectation", "html-parser-1063"

    it_behaves_like "shared parser constructor expectation", "html-parser-1081"

    it_behaves_like "shared parser constructor expectation", "html-parser-1099"

    it_behaves_like "shared parser constructor expectation", "html-parser-1120"

    it_behaves_like "shared parser constructor expectation", "html-parser-1138"

    it_behaves_like "shared parser constructor expectation", "html-parser-1160"

    it_behaves_like "shared parser constructor expectation", "html-parser-1184"

    it_behaves_like "shared parser constructor expectation", "html-parser-1211"

    it_behaves_like "shared parser constructor expectation", "html-parser-1225"

    it_behaves_like "shared parser constructor expectation", "html-parser-1239"

    it_behaves_like "shared parser constructor expectation", "html-parser-1253"

    it_behaves_like "shared parser constructor expectation", "html-parser-1273"

    it_behaves_like "shared parser constructor expectation", "html-parser-1289"

    it_behaves_like "shared parser constructor expectation", "html-parser-1311"

    it_behaves_like "shared parser constructor expectation", "html-parser-1325"

    it_behaves_like "shared parser constructor expectation", "html-parser-1341"

    it_behaves_like "shared parser constructor expectation", "html-parser-1356-example-1"
    it_behaves_like "shared parser constructor expectation", "html-parser-1356-example-2"
    it_behaves_like "shared parser constructor expectation", "html-parser-1356-example-3"

    it_behaves_like "shared parser constructor expectation", "html-parser-1469-example-1"
    it_behaves_like "shared parser constructor expectation", "html-parser-1469-example-2"

    it_behaves_like "shared parser constructor expectation", "html-parser-1496"

    it_behaves_like "shared parser constructor expectation", "html-parser-1511"

    it_behaves_like "shared parser constructor expectation", "html-parser-1524"

    it_behaves_like "shared parser constructor expectation", "html-parser-1537"

    it_behaves_like "shared parser constructor expectation", "html-parser-1560"

    it_behaves_like "shared parser constructor expectation", "html-parser-1580"

    it_behaves_like "shared parser constructor expectation", "html-parser-1597"

    it_behaves_like "shared parser constructor expectation", "html-parser-1619"

    it_behaves_like "shared parser constructor expectation", "html-parser-1633"

    it_behaves_like "shared parser constructor expectation", "html-parser-1644-example-1"

    it_behaves_like "shared parser constructor expectation", "html-parser-1652-example-1"

    it_behaves_like "shared parser constructor expectation", "html-parser-1660-example-1"

    it_behaves_like "shared parser constructor expectation", "html-parser-1668-example-1"

    it_behaves_like "shared parser constructor expectation", "html-parser-1676-example-1"

    it_behaves_like "shared parser constructor expectation", "html-parser-1684"

    it_behaves_like "shared parser constructor expectation", "html-parser-1695"

    it_behaves_like "shared parser constructor expectation", "html-parser-1706-example-1"
  end
end
