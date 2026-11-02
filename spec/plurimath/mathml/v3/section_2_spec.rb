require "spec_helper"
require_relative "../../../support/shared_parser_examples"

RSpec.describe Plurimath::Mathml::Parser do
  subject(:formula) { described_class.new(exp).parse }

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-2-15", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-2-35", "xml-parser-expectations"
end
