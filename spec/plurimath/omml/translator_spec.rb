# frozen_string_literal: true

require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Omml::Translator do
  describe "#omml_to_plurimath" do
    it_behaves_like "shared renderer fixture", "renderer-translator-operand-limUpp-text"
    it_behaves_like "shared renderer fixture", "renderer-translator-operand-limUpp-operator"
    it_behaves_like "shared renderer fixture", "renderer-translator-operand-limLow-text"
    it_behaves_like "shared renderer fixture", "renderer-translator-operand-limLow-operator"

    it "raises for unsupported typed nodes" do
      expect { described_class.new.omml_to_plurimath(Object.new) }
        .to raise_error(
          Plurimath::Omml::UnsupportedNodeError,
          /Unsupported OMML typed node/,
        )
    end

    it "returns nil for non-semantic typed OMML nodes" do
      require "omml"

      Omml::Configuration.populate_context!
      ignored_types = %w[
        CTEmpty
        CTFPr
        CTOMathArgPr
        CTOMathParaPr
        CTCtrlPr
        CTBoxPr
      ]

      ignored_types.each do |type_name|
        node = Omml::Models.const_get(type_name)
          .new(lutaml_register: Omml::Configuration.context_id)

        expect(described_class.new.omml_to_plurimath(node)).to be_nil
      end
    end
  end

  describe "Plurimath::Omml#to_formula" do
    it_behaves_like "shared renderer fixture", "renderer-translator-fixture-001"
    it_behaves_like "shared renderer fixture", "renderer-translator-fixture-057"
    it_behaves_like "shared renderer fixture", "renderer-translator-fixture-121"
    it_behaves_like "shared renderer fixture", "renderer-translator-fixture-187"

    context "when the omml context has not been populated yet" do
      before do
        require "omml"
        Omml::Configuration.reset_context!
      end
      it_behaves_like "shared renderer fixture", "renderer-translator-reset-context"
    end

    it_behaves_like "shared renderer fixture", "renderer-omml-translator-translator-106-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-translator-translator-122-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-translator-translator-152-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-translator-translator-173-1"

    it_behaves_like "shared renderer fixture", "renderer-translator-word-content-1-acceptance"
    it_behaves_like "shared renderer fixture", "renderer-translator-word-content-1-output"
    it_behaves_like "shared renderer fixture", "renderer-translator-word-content-2-output"
    it_behaves_like "shared renderer fixture", "renderer-translator-word-content-3-acceptance"
    it_behaves_like "shared renderer fixture", "renderer-translator-word-content-4-acceptance"
    it_behaves_like "shared renderer fixture", "renderer-translator-word-content-5-acceptance"
  end
end
