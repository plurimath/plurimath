# frozen_string_literal: true

require "spec_helper"
require_relative "../support/shared_facade_examples"

RSpec.describe Plurimath::BaseNumberPrefix do
  describe "Parser module" do
    let(:parser_class) do
      Class.new(Parslet::Parser) do
        include Plurimath::BaseNumberPrefix::Parser

        rule(:base_prefixed_number) do
          hex_number | binary_number | octal_number
        end

        root(:base_prefixed_number)
      end
    end

    it_behaves_like "shared facade expectation", "facade-base-number-prefix-19"

    it_behaves_like "shared facade expectation", "facade-base-number-prefix-24"

    it_behaves_like "shared facade expectation", "facade-base-number-prefix-29"

    it_behaves_like "shared facade expectation", "facade-base-number-prefix-34"

    it_behaves_like "shared facade expectation", "facade-base-number-prefix-39"

    it_behaves_like "shared facade expectation", "facade-base-number-prefix-44"

    it_behaves_like "shared facade expectation", "facade-base-number-prefix-49"
  end

  describe "Transform module" do
    let(:transform_class) do
      Class.new(Parslet::Transform) do
        include Plurimath::BaseNumberPrefix::Transform
      end
    end

    it_behaves_like "shared facade expectation", "facade-base-number-prefix-61"

    it_behaves_like "shared facade expectation", "facade-base-number-prefix-68"

    it_behaves_like "shared facade expectation", "facade-base-number-prefix-75"
  end

  describe "integration with real parsers" do
    it_behaves_like "shared facade expectation", "facade-base-number-prefix-91-iteration-1"
    it_behaves_like "shared facade expectation", "facade-base-number-prefix-91-iteration-2"
    it_behaves_like "shared facade expectation", "facade-base-number-prefix-91-iteration-3"
    it_behaves_like "shared facade expectation", "facade-base-number-prefix-91-iteration-4"
  end
end
