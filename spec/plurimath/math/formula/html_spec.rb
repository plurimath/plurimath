require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Formula do
  describe ".to_html" do
    subject(:formula) { exp.to_html.gsub(/\s/, "") }

    it_behaves_like "shared renderer fixture", "formula-html-7-1"

    it_behaves_like "shared renderer fixture", "formula-html-20-1"

    it_behaves_like "shared renderer fixture", "formula-html-41-1"

    it_behaves_like "shared renderer fixture", "formula-html-57-1"

    it_behaves_like "shared renderer fixture", "formula-html-78-1"

    it_behaves_like "shared renderer fixture", "formula-html-108-1"

    it_behaves_like "shared renderer fixture", "formula-html-127-1"

    it_behaves_like "shared renderer fixture", "formula-html-149-1"

    it_behaves_like "shared renderer fixture", "formula-html-171-1"

    it_behaves_like "shared renderer fixture", "formula-html-219-1"

    it_behaves_like "shared renderer fixture", "formula-html-237-1"

    it_behaves_like "shared renderer fixture", "formula-html-253-1"

    it_behaves_like "shared renderer fixture", "formula-html-269-1"

    it_behaves_like "shared renderer fixture", "formula-html-285-1"

    it_behaves_like "shared renderer fixture", "formula-html-301-1"

    it_behaves_like "shared renderer fixture", "formula-html-317-1"

    it_behaves_like "shared renderer fixture", "formula-html-337-1"

    it_behaves_like "shared renderer fixture", "formula-html-357-1"

    it_behaves_like "shared renderer fixture", "formula-html-377-1"

    it_behaves_like "shared renderer fixture", "formula-html-396-1"

    it_behaves_like "shared renderer fixture", "formula-html-415-1"

    it_behaves_like "shared renderer fixture", "formula-html-434-1"

    it_behaves_like "shared renderer fixture", "formula-html-453-1"

    it_behaves_like "shared renderer fixture", "formula-html-470-1"

    it_behaves_like "shared renderer fixture", "formula-html-504-1"

    it_behaves_like "shared renderer fixture", "formula-html-522-1"

    it_behaves_like "shared renderer fixture", "formula-html-545-1"

    it_behaves_like "shared renderer fixture", "formula-html-571-1"

    it_behaves_like "shared renderer fixture", "formula-html-593-1"

    it_behaves_like "shared renderer fixture", "formula-html-613-1"

    it_behaves_like "shared renderer fixture", "formula-html-626-1"

    it_behaves_like "shared renderer fixture", "formula-html-639-1"

    it_behaves_like "shared renderer fixture", "formula-html-654-1"

    it_behaves_like "shared renderer fixture", "formula-html-669-1"

    it_behaves_like "shared renderer fixture", "formula-html-691-1"

    it_behaves_like "shared renderer fixture", "formula-html-706-1"

    it_behaves_like "shared renderer fixture", "formula-html-733-1"

    it_behaves_like "shared renderer fixture", "formula-html-760-1"

    it_behaves_like "shared renderer fixture", "formula-html-810-1"

    it_behaves_like "shared renderer fixture", "formula-html-862-1"

    it_behaves_like "shared renderer fixture", "formula-html-888-1"

    it_behaves_like "shared renderer fixture", "formula-html-909-1"

    it_behaves_like "shared renderer fixture", "formula-html-925-1"

    it_behaves_like "shared renderer fixture", "formula-html-946-1"

    it_behaves_like "shared renderer fixture", "formula-html-966-1"

    it_behaves_like "shared renderer fixture", "formula-html-982-1"

    it_behaves_like "shared renderer fixture", "formula-html-998-1"

    it_behaves_like "shared renderer fixture", "formula-html-1015-1"

    it_behaves_like "shared renderer fixture", "formula-html-1038-1"

    it_behaves_like "shared renderer fixture", "formula-html-1058-1"

    it_behaves_like "shared renderer fixture", "formula-html-1078-1"

    it_behaves_like "shared renderer fixture", "formula-html-1098-1"

    it_behaves_like "shared renderer fixture", "formula-html-1121-1"

    it_behaves_like "shared renderer fixture", "formula-html-1141-1"

    it_behaves_like "shared renderer fixture", "formula-html-1165-1"

    it_behaves_like "shared renderer fixture", "formula-html-1191-1"

    it_behaves_like "shared renderer fixture", "formula-html-1220-1"

    it_behaves_like "shared renderer fixture", "formula-html-1236-1"

    it_behaves_like "shared renderer fixture", "formula-html-1252-1"

    it_behaves_like "shared renderer fixture", "formula-html-1268-1"

    it_behaves_like "shared renderer fixture", "formula-html-1290-1"

    it_behaves_like "shared renderer fixture", "formula-html-1308-1"
  end
end
