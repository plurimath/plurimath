# frozen_string_literal: true

require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Html::Parser do
  describe ".parse" do
    subject(:formula) do
      described_class.new(html).parse
    end

    let(:formula_class) { Plurimath::Math::Formula }
    let(:html) { exp.to_html.gsub(/\s/, "") }
    let(:number_value) { Plurimath::Math::Number.new("2") }
    let(:text_value) { Plurimath::Math::Function::Text.new("x") }

    it_behaves_like "shared renderer fixture", "renderer-html-to_html_round_trip-to_html_round_trip-16-1"

    it_behaves_like "shared renderer fixture", "renderer-html-to_html_round_trip-to_html_round_trip-28-1"

    it_behaves_like "shared renderer fixture", "renderer-html-to_html_round_trip-to_html_round_trip-43-1"

    it_behaves_like "shared renderer fixture", "renderer-html-to_html_round_trip-to_html_round_trip-58-1"

    it_behaves_like "shared renderer fixture", "renderer-html-to_html_round_trip-to_html_round_trip-73-1"

    it_behaves_like "shared renderer fixture", "renderer-html-to_html_round_trip-to_html_round_trip-85-1"

    it_behaves_like "shared renderer fixture", "renderer-html-to_html_round_trip-to_html_round_trip-101-1"

    it_behaves_like "shared renderer fixture", "renderer-html-to_html_round_trip-to_html_round_trip-113-1"

    it_behaves_like "shared renderer fixture", "renderer-html-to_html_round_trip-to_html_round_trip-131-1"
  end
end
