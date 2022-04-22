require_relative "../../../lib/plurimath/mathml"

RSpec.describe Plurimath::Mathml::Parse do

  subject(:formula) { Plurimath::Mathml::Parse.new.parse(exp.gsub("\n", "").gsub(" ", "")) }

  context "contains mathml string of sin formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <mi>sin</mi>
              <mrow>
                <mo>(</mo>
                <mn>1</mn>
                <mo>)</mo>
              </mrow>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sin from mathml string" do
      expected_value = {
                        :open=>"math",
                        :attributes=>[{:name=>"xmlns", :value=>"http://www.w3.org/1998/Math/MathML"}],
                        :iteration=>
                        {:tag=>
                          {:open=>"mstyle",
                           :attributes=>[{:name=>"displaystyle", :value=>"true"}],
                           :iteration=>
                            {:tag=>
                              {:open=>"mrow",
                               :attributes=>[],
                               :iteration=>
                                {:tag=>{:open=>"mi", :attributes=>[], :iteration=>{:class=>"sin"}, :close=>"mi"},
                                 :sequence=>
                                  {:tag=>
                                    {:open=>"mrow",
                                     :attributes=>[],
                                     :iteration=>
                                      {:tag=>{:open=>"mo", :attributes=>[], :iteration=>{:symbol=>"("}, :close=>"mo"},
                                       :sequence=>
                                        {:tag=>{:open=>"mn", :attributes=>[], :iteration=>{:number=>"1"}, :close=>"mn"},
                                         :sequence=>{:tag=>{:open=>"mo", :attributes=>[], :iteration=>{:symbol=>")"}, :close=>"mo"}}},
                                       :iteration=>""},
                                     :close=>"mrow"}},
                                 :iteration=>""},
                               :close=>"mrow"},
                             :iteration=>""},
                           :close=>"mstyle"},
                         :iteration=>""},
                        :close=>"math"
                      }
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum and prod formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <munderover>
              <mo>&#x2211;</mo>
              <mrow>
                <mo>(</mo>
                <mo>&#x220f;</mo>
                <mo>)</mo>
              </mrow>
              <mo>&#x22c1;</mo>
            </munderover>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sum and prod" do
      expected_value = {
                        :open=>"math",
                        :attributes=>[{:name=>"xmlns", :value=>"http://www.w3.org/1998/Math/MathML"}],
                        :iteration=>
                        {:tag=>
                          {:open=>"mstyle",
                           :attributes=>[{:name=>"displaystyle", :value=>"true"}],
                           :iteration=>
                            {:tag=>
                              {:open=>"munderover",
                               :attributes=>[],
                               :iteration=>
                                {:tag=>{:open=>"mo", :attributes=>[], :iteration=>{:symbol=>"&#x2211;"}, :close=>"mo"},
                                 :sequence=>
                                  {:tag=>
                                    {:open=>"mrow",
                                     :attributes=>[],
                                     :iteration=>
                                      {:tag=>{:open=>"mo", :attributes=>[], :iteration=>{:symbol=>"("}, :close=>"mo"},
                                       :sequence=>
                                        {:tag=>{:open=>"mo", :attributes=>[], :iteration=>{:symbol=>"&#x220f;"}, :close=>"mo"},
                                         :sequence=>{:tag=>{:open=>"mo", :attributes=>[], :iteration=>{:symbol=>")"}, :close=>"mo"}}},
                                       :iteration=>""},
                                     :close=>"mrow"},
                                   :sequence=>{:tag=>{:open=>"mo", :attributes=>[], :iteration=>{:symbol=>"&#x22c1;"}, :close=>"mo"}}},
                                 :iteration=>""},
                               :close=>"munderover"},
                             :iteration=>""},
                           :close=>"mstyle"},
                         :iteration=>""},
                        :close=>"math"
                      }
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mi>x</mi>
                <mi>s</mi>
              </munderover>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sum and prod" do
      expected_value = {
                        :open=>"math",
                        :attributes=>[{:name=>"xmlns", :value=>"http://www.w3.org/1998/Math/MathML"}],
                        :iteration=>
                        {:tag=>
                          {:open=>"mstyle",
                           :attributes=>[{:name=>"displaystyle", :value=>"true"}],
                           :iteration=>
                            {:tag=>
                              {:open=>"mrow",
                               :attributes=>[],
                               :iteration=>
                                {:tag=>
                                  {:open=>"munderover",
                                   :attributes=>[],
                                   :iteration=>
                                    {:tag=>{:open=>"mo", :attributes=>[], :iteration=>{:symbol=>"&#x2211;"}, :close=>"mo"},
                                     :sequence=>
                                      {:tag=>{:open=>"mi", :attributes=>[], :iteration=>{:text=>"x"}, :close=>"mi"},
                                       :sequence=>{:tag=>{:open=>"mi", :attributes=>[], :iteration=>{:text=>"s"}, :close=>"mi"}}},
                                     :iteration=>""},
                                   :close=>"munderover"},
                                 :iteration=>""},
                               :close=>"mrow"},
                             :iteration=>""},
                           :close=>"mstyle"},
                         :iteration=>""},
                        :close=>"math"
                      }
      expect(formula).to eq(expected_value)
    end
  end
end
