require "spec_helper"
require_relative "../../../support/shared_parser_examples"
require_relative "../../../support/shared_xml_parser_examples"

RSpec.describe Plurimath::Mathml::Parser do
  subject(:formula) { described_class.new(exp).parse }

  it_behaves_like "shared XML parser models", "mathml/tokens", %w[
    mathml-tokens-027
    mathml-tokens-028
    mathml-tokens-029
    mathml-tokens-030
    mathml-tokens-031
    mathml-tokens-032
    mathml-tokens-033
    mathml-tokens-034
    mathml-tokens-035
    mathml-tokens-036
    mathml-tokens-037
    mathml-tokens-038
    mathml-tokens-039
    mathml-tokens-040
    mathml-tokens-041
    mathml-tokens-042
    mathml-tokens-043
    mathml-tokens-044
    mathml-tokens-045
    mathml-tokens-046
    mathml-tokens-047
    mathml-tokens-048
    mathml-tokens-049
    mathml-tokens-050
    mathml-tokens-051
    mathml-tokens-052
    mathml-tokens-053
    mathml-tokens-054
    mathml-tokens-055
    mathml-tokens-056
    mathml-tokens-057
    mathml-tokens-058
    mathml-tokens-059
    mathml-tokens-060
    mathml-tokens-061
    mathml-tokens-062
    mathml-tokens-063
    mathml-tokens-064
    mathml-tokens-065
    mathml-tokens-066
    mathml-tokens-067
    mathml-tokens-068
    mathml-tokens-069
    mathml-tokens-070
    mathml-tokens-071
    mathml-tokens-072
    mathml-tokens-073
    mathml-tokens-074
    mathml-tokens-075
    mathml-tokens-076
    mathml-tokens-077
    mathml-tokens-078
    mathml-tokens-079
    mathml-tokens-080
    mathml-tokens-081
    mathml-tokens-082
    mathml-tokens-083
    mathml-tokens-084
    mathml-tokens-085
    mathml-tokens-086
    mathml-tokens-087
  ]
  it_behaves_like "shared XML parser models", "mathml/scripts", %w[
    mathml-scripts-021
    mathml-scripts-022
    mathml-scripts-023
    mathml-scripts-024
    mathml-scripts-025
    mathml-scripts-026
    mathml-scripts-027
    mathml-scripts-028
    mathml-scripts-029
    mathml-scripts-030
    mathml-scripts-031
    mathml-scripts-032
    mathml-scripts-033
    mathml-scripts-034
    mathml-scripts-035
    mathml-scripts-036
    mathml-scripts-037
    mathml-scripts-038
    mathml-scripts-039
    mathml-scripts-040
    mathml-scripts-041
    mathml-scripts-042
    mathml-scripts-043
    mathml-scripts-044
    mathml-scripts-045
    mathml-scripts-046
    mathml-scripts-047
    mathml-scripts-048
    mathml-scripts-049
  ]
  it_behaves_like "shared XML parser models", "mathml/fences", %w[
    mathml-fences-004
    mathml-fences-005
    mathml-fences-006
    mathml-fences-007
    mathml-fences-008
    mathml-fences-009
    mathml-fences-010
    mathml-fences-011
    mathml-fences-012
    mathml-fences-013
    mathml-fences-014
    mathml-fences-015
    mathml-fences-016
    mathml-fences-018
    mathml-fences-019
    mathml-fences-020
    mathml-fences-021
    mathml-fences-022
    mathml-fences-023
    mathml-fences-024
    mathml-fences-025
    mathml-fences-026
    mathml-fences-027
    mathml-fences-028
    mathml-fences-029
    mathml-fences-030
    mathml-fences-031
  ]
  it_behaves_like "shared XML parser models", "mathml/partial-render", %w[
    mathml-partial-020
    mathml-partial-024
    mathml-partial-025
    mathml-partial-026
  ]
  it_behaves_like "shared XML parser models", "mathml/over-under", %w[
    mathml-over-under-027
    mathml-over-under-028
    mathml-over-under-029
    mathml-over-under-030
    mathml-over-under-031
    mathml-over-under-032
    mathml-over-under-033
    mathml-over-under-034
  ]
  it_behaves_like "shared XML parser models", "mathml/roots", ["mathml-roots-004"]
  it_behaves_like "shared XML parser models", "mathml/fractions", ["mathml-fractions-013"]

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-4-164", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-4-241", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-4-332", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-4-393", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-4-485", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-4-552", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-4-581", "xml-parser-expectations"

  it_behaves_like "shared parser constructor expectation", "mathml-authored-section-4-642", "xml-parser-expectations"
end
