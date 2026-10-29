require "spec_helper"
require_relative "../../../support/shared_parser_examples"
require_relative "../../../support/shared_xml_parser_examples"

RSpec.describe Plurimath::Mathml::Parser do
  subject(:formula) { described_class.new(exp).parse }

  it_behaves_like "shared XML parser models", "mathml/tokens", %w[
    mathml-tokens-014
    mathml-tokens-015
    mathml-tokens-016
    mathml-tokens-017
    mathml-tokens-018
    mathml-tokens-019
    mathml-tokens-020
    mathml-tokens-021
    mathml-tokens-022
    mathml-tokens-023
    mathml-tokens-024
    mathml-tokens-025
    mathml-tokens-026
  ]
  it_behaves_like "shared XML parser models", "mathml/fractions", %w[
    mathml-fractions-002
    mathml-fractions-003
    mathml-fractions-004
    mathml-fractions-005
    mathml-fractions-007
    mathml-fractions-008
    mathml-fractions-009
    mathml-fractions-010
    mathml-fractions-011
  ]
  it_behaves_like "shared XML parser models", "mathml/scripts", %w[
    mathml-scripts-013
    mathml-scripts-015
    mathml-scripts-016
    mathml-scripts-018
    mathml-scripts-019
    mathml-scripts-020
  ]
  it_behaves_like "shared XML parser models", "mathml/over-under", ["mathml-over-under-021"]
  it_behaves_like "shared XML parser models", "mathml/partial-render", %w[
    mathml-partial-009
    mathml-partial-010
    mathml-partial-011
    mathml-partial-012
    mathml-partial-013
    mathml-partial-014
    mathml-partial-016
    mathml-partial-017
    mathml-partial-018
    mathml-partial-019
  ]
  it_behaves_like "shared XML parser models", "mathml/fences", %w[
    mathml-fences-001
    mathml-fences-002
    mathml-fences-003
  ]
  it_behaves_like "shared XML parser models", "mathml/enclose", ["mathml-enclose-001"]
  it_behaves_like "shared XML parser models", "mathml/elementary-math", %w[
    mathml-elementary-math-001
    mathml-elementary-math-002
    mathml-elementary-math-003
    mathml-elementary-math-004
    mathml-elementary-math-005
    mathml-elementary-math-006
    mathml-elementary-math-007
    mathml-elementary-math-008
    mathml-elementary-math-009
    mathml-elementary-math-010
  ]

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-89", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-137", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-225", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-254", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-298", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-364", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-416", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-461", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-510", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-559", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-612", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-661", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-736", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-3-837", "xml-parser-expectations"
end
