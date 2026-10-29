require "spec_helper"
require_relative "../../support/shared_parser_examples"

RSpec.describe Plurimath::Latex::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    it_behaves_like "shared parser constructor expectation", "latex-parser-7"

    context "when locale uses comma as the decimal separator" do
      around do |example|
        Plurimath.with_configuration do |config|
          config.locale = :fr
          example.run
        end
      end

      it_behaves_like "shared parser constructor expectation", "latex-parser-33"

      it_behaves_like "shared parser constructor expectation", "latex-parser-44"

      it_behaves_like "shared parser constructor expectation", "latex-parser-57"

      it_behaves_like "shared parser constructor expectation", "latex-parser-69"
    end

    context "when locale uses full stop as the decimal separator" do
      around do |example|
        Plurimath.with_configuration do |config|
          config.locale = :en
          example.run
        end
      end

      it_behaves_like "shared parser constructor expectation", "latex-parser-97"
    end

    context "when locale uses Arabic decimal separator" do
      around do |example|
        Plurimath.with_configuration do |config|
          config.locale = :ar
          example.run
        end
      end

      it_behaves_like "shared parser constructor expectation", "latex-parser-119"

      it_behaves_like "shared parser constructor expectation", "latex-parser-130"
    end

    it_behaves_like "shared parser constructor expectation", "latex-parser-142"

    it_behaves_like "shared parser constructor expectation", "latex-parser-161"

    it_behaves_like "shared parser constructor expectation", "latex-parser-184"

    it_behaves_like "shared parser constructor expectation", "latex-parser-213"

    it_behaves_like "shared parser constructor expectation", "latex-parser-230"

    it_behaves_like "shared parser constructor expectation", "latex-parser-243"

    it_behaves_like "shared parser constructor expectation", "latex-parser-262"

    it_behaves_like "shared parser constructor expectation", "latex-parser-277"

    it_behaves_like "shared parser constructor expectation", "latex-parser-299"

    it_behaves_like "shared parser constructor expectation", "latex-parser-321"

    it_behaves_like "shared parser constructor expectation", "latex-parser-339"

    it_behaves_like "shared parser constructor expectation", "latex-parser-357"

    it_behaves_like "shared parser constructor expectation", "latex-parser-381"

    it_behaves_like "shared parser constructor expectation", "latex-parser-399"

    it_behaves_like "shared parser constructor expectation", "latex-parser-421"

    it_behaves_like "shared parser constructor expectation", "latex-parser-460"

    it_behaves_like "shared parser constructor expectation", "latex-parser-499"

    it_behaves_like "shared parser constructor expectation", "latex-parser-550"

    it_behaves_like "shared parser constructor expectation", "latex-parser-580"

    it_behaves_like "shared parser constructor expectation", "latex-parser-611"

    it_behaves_like "shared parser constructor expectation", "latex-parser-647"

    it_behaves_like "shared parser constructor expectation", "latex-parser-675"

    it_behaves_like "shared parser constructor expectation", "latex-parser-714"

    it_behaves_like "shared parser constructor expectation", "latex-parser-753"

    it_behaves_like "shared parser constructor expectation", "latex-parser-781"

    it_behaves_like "shared parser constructor expectation", "latex-parser-839"

    it_behaves_like "shared parser constructor expectation", "latex-parser-881"

    it_behaves_like "shared parser constructor expectation", "latex-parser-901"

    it_behaves_like "shared parser constructor expectation", "latex-parser-919"

    it_behaves_like "shared parser constructor expectation", "latex-parser-949"

    it_behaves_like "shared parser constructor expectation", "latex-parser-998"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1013"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1031"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1048"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1065"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1076"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1098"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1137"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1166"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1195"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1255"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1331"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1364"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1403"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1480"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1706"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1879"

    it_behaves_like "shared parser constructor expectation", "latex-parser-1960"

    it_behaves_like "shared parser constructor expectation", "latex-parser-2036"

    it_behaves_like "shared parser constructor expectation", "latex-parser-2085"

    it_behaves_like "shared parser constructor expectation", "latex-parser-2167"

    it_behaves_like "shared parser constructor expectation", "latex-parser-2224"

    it_behaves_like "shared parser constructor expectation", "latex-parser-2277"

    it_behaves_like "shared parser constructor expectation", "latex-parser-2350"

    it_behaves_like "shared parser constructor expectation", "latex-parser-2438"

    it_behaves_like "shared parser constructor expectation", "latex-parser-2523"

    it_behaves_like "shared parser constructor expectation", "latex-parser-2623"

    it_behaves_like "shared parser constructor expectation", "latex-parser-2908"

    it_behaves_like "shared parser constructor expectation", "latex-parser-3022"

    it_behaves_like "shared parser constructor expectation", "latex-parser-3056"

    it_behaves_like "shared parser constructor expectation", "latex-parser-3486"

    it_behaves_like "shared parser constructor expectation", "latex-parser-3848"

    it_behaves_like "shared parser constructor expectation", "latex-parser-3900"

    it_behaves_like "shared parser constructor expectation", "latex-parser-4298"

    it_behaves_like "shared parser constructor expectation", "latex-parser-4696"

    it_behaves_like "shared parser constructor expectation", "latex-parser-5021"

    it_behaves_like "shared parser constructor expectation", "latex-parser-5124"
    # set counting numbers

    it_behaves_like "shared parser constructor expectation", "latex-parser-5197"

    it_behaves_like "shared parser constructor expectation", "latex-parser-5482"

    it_behaves_like "shared parser constructor expectation", "latex-parser-5582"

    it_behaves_like "shared parser constructor expectation", "latex-parser-5667"

    it_behaves_like "shared parser constructor expectation", "latex-parser-5752"

    it_behaves_like "shared parser constructor expectation", "latex-parser-5846"

    it_behaves_like "shared parser constructor expectation", "latex-parser-5870"

    it_behaves_like "shared parser constructor expectation", "latex-parser-5897"

    it_behaves_like "shared parser constructor expectation", "latex-parser-6076"

    it_behaves_like "shared parser constructor expectation", "latex-parser-6233"

    it_behaves_like "shared parser constructor expectation", "latex-parser-6621"

    it_behaves_like "shared parser constructor expectation", "latex-parser-6875"

    it_behaves_like "shared parser constructor expectation", "latex-parser-7201"

    it_behaves_like "shared parser constructor expectation", "latex-parser-7417"

    it_behaves_like "shared parser constructor expectation", "latex-parser-7483"

    it_behaves_like "shared parser constructor expectation", "latex-parser-7539"
    # structural_response_representation_schema_annotated => 54

    it_behaves_like "shared parser constructor expectation", "latex-parser-7595"

    it_behaves_like "shared parser constructor expectation", "latex-parser-7664"

    it_behaves_like "shared parser constructor expectation", "latex-parser-7697"

    it_behaves_like "shared parser constructor expectation", "latex-parser-7724"

    it_behaves_like "shared parser constructor expectation", "latex-parser-7781"

    it_behaves_like "shared parser constructor expectation", "latex-parser-7888"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8034"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8173"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8294"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8412"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8530"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8552"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8576"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8642"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8661"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8683"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8761"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8867"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8908"

    it_behaves_like "shared parser constructor expectation", "latex-parser-8965"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9116"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9173"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9292"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9324"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9381"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9421"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9465"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9505"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9562"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9612"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9653"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9695"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9734"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9778"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9817"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9869"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9903"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9955"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9979"

    it_behaves_like "shared parser constructor expectation", "latex-parser-9998"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10017"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10036"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10071"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10090"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10125"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10149"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10168"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10205"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10231"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10268"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10294"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10331"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10357"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10770"

    it_behaves_like "shared parser constructor expectation", "latex-parser-10936"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11102"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11337"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11359"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11381"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11403"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11488"
    # results_schema_annotated

    it_behaves_like "shared parser constructor expectation", "latex-parser-11669"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11693"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11734"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11761"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11806"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11825"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11840"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11855"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11874"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11893"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11939"

    it_behaves_like "shared parser constructor expectation", "latex-parser-11985"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12006"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12030"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12084"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12102"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12117"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12173"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12193"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12214"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12232"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12258"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12284"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12310"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12334"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12349"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12373"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12388"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12412"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12433"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12449"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12481"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12513"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12545"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12567"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12586"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12611"
    # domain_schema_annotated

    it_behaves_like "shared parser constructor expectation", "latex-parser-12635"
    # finite_element_analysis_control_and_result_schema_annotated

    it_behaves_like "shared parser constructor expectation", "latex-parser-12734"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12760"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12786"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12810"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12873"

    it_behaves_like "shared parser constructor expectation", "latex-parser-12931"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13033"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13112"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13175"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13284"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13403"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13556"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13625"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13667"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13706"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13746"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13774"
    # 07-conditions.adoc

    it_behaves_like "shared parser constructor expectation", "latex-parser-13814"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13887"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13913"

    it_behaves_like "shared parser constructor expectation", "latex-parser-13954"

    it_behaves_like "shared parser constructor expectation", "latex-parser-14034"

    it_behaves_like "shared parser constructor expectation", "latex-parser-14167"

    it_behaves_like "shared parser constructor expectation", "latex-parser-14184"

    it_behaves_like "shared parser constructor expectation", "latex-parser-14317"

    it_behaves_like "shared parser constructor expectation", "latex-parser-14407"

    it_behaves_like "shared parser constructor expectation", "latex-parser-14431"

    it_behaves_like "shared parser constructor expectation", "latex-parser-14454"

    it_behaves_like "shared parser constructor expectation", "latex-parser-14469"

    it_behaves_like "shared parser constructor expectation", "latex-parser-14487"

    it_behaves_like "shared parser constructor expectation", "latex-parser-14516"

    it_behaves_like "shared parser constructor expectation", "latex-parser-14537"
  end
end
