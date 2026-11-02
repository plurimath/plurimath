require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math do
  describe ".parse" do
    subject(:formula) { described_class.parse(string, :asciimath) }

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-7-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-19-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-36-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-54-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-70-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-86-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-102-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-118-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-139-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-153-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-171-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-185-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-202-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-216-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-230-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-244-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-258-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-272-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-282-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-292-1"

    it_behaves_like "shared renderer fixture", "renderer-integration-asciimath-asciimath-302-1"
  end
end

SUPPORTED_LANGUAGES = %i[omml latex mathml asciimath].freeze

def convert(formula)
  SUPPORTED_LANGUAGES.each { |lang| re_convert(formula, lang) }
end

def re_convert(formula, type)
  SUPPORTED_LANGUAGES.map do |lang|
    conversion(
      string_to_formula(
        conversion(formula, lang),
        lang,
      ),
      type,
    )
  end
end

def string_to_formula(string, type)
  described_class.parse(string, type)
end

def conversion(formula, type)
  formula.send("to_#{type}")
end
