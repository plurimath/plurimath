require "spec_helper"
require_relative "../../../support/shared_xml_parser_examples"

RSpec.describe Plurimath::Mathml::Parser do
  it_behaves_like "shared XML parser models", "mathml/scripts", ["mathml-scripts-012"]
end
