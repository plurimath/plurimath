require "spec_helper"
require_relative "../../support/shared_parser_examples"
require_relative "../../support/shared_xml_parser_examples"

RSpec.describe Plurimath::Mathml::Parser do
  subject(:formula) { described_class.new(exp).parse }

  it_behaves_like "shared XML parser models", "mathml/layout", %w[
    mathml-layout-001
    mathml-layout-002
    mathml-layout-003
    mathml-layout-004
    mathml-layout-005
    mathml-layout-006
    mathml-layout-007
  ]
  # mathml-over-under-016: a bare <mo>frac</mo> is a literal Symbol, not
  # Function::Frac; an actual fraction uses <mfrac>. See PR #450.
  it_behaves_like "shared XML parser models", "mathml/over-under", %w[
    mathml-over-under-002
    mathml-over-under-003
    mathml-over-under-005
    mathml-over-under-006
    mathml-over-under-007
    mathml-over-under-008
    mathml-over-under-009
    mathml-over-under-010
    mathml-over-under-011
    mathml-over-under-012
    mathml-over-under-013
    mathml-over-under-014
    mathml-over-under-016
    mathml-over-under-017
  ]
  it_behaves_like "shared XML parser models", "mathml/scripts", %w[
    mathml-scripts-001
    mathml-scripts-002
    mathml-scripts-003
    mathml-scripts-005
    mathml-scripts-009
    mathml-scripts-011
  ]
  it_behaves_like "shared XML parser models", "mathml/tokens", %w[
    mathml-tokens-003
    mathml-tokens-004
    mathml-tokens-005
    mathml-tokens-006
    mathml-tokens-007
    mathml-tokens-009
    mathml-tokens-010
  ]
  it_behaves_like "shared XML parser models", "mathml/roots", %w[
    mathml-roots-001
    mathml-roots-002
    mathml-roots-003
  ]
  it_behaves_like "shared XML parser models", "mathml/partial-render", %w[
    mathml-partial-001
    mathml-partial-002
    mathml-partial-005
    mathml-partial-006
    mathml-partial-007
  ]
  it_behaves_like "shared XML parser models", "mathml/fractions", ["mathml-fractions-001"]

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-74", "xml-parser-expectations"
  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-84", "xml-parser-expectations"

  # A text run round-trips a letter through its UNICODE_SYMBOLS name, and
  # Hash#invert keeps only the last key for a duplicated name. Two Greek names
  # were each shared by two different letters: ς sat on "beta" with β, and Ω sat
  # on "omega" with ω — so a real β came back as ς, and a lowercase ω came back
  # as a capital Ω. (Other names are still shared — "hat", "bar", "ul" — but
  # those are alternate spellings of one concept rather than mislabelled
  # letters, and belong with the wider Text placeholder issue.)
  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-103-iteration-1", "xml-parser-expectations"
  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-103-iteration-2", "xml-parser-expectations"
  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-103-iteration-3", "xml-parser-expectations"
  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-103-iteration-4", "xml-parser-expectations"

  # The promotion above must stay confined to accent positions: outside one, a
  # combining tilde is ordinary content and has to survive untouched.
  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-115", "xml-parser-expectations"
  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-120", "xml-parser-expectations"
  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-129", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-159", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-186", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-203", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-224", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-254", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-294", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-349", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-391", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-424", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-453", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-478", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-501", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-525", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-558", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-584", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-607", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-720", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-858", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-903", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-951", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-994", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-parser-1028", "xml-parser-expectations"
end
