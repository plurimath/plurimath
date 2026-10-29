require "spec_helper"
require_relative "../../support/shared_parser_examples"

RSpec.describe Plurimath::UnicodeMath::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    context "when parsing decimal markers" do
      it_behaves_like "shared parser constructor expectation", "unicode-math-parser-9"

      it_behaves_like "shared parser constructor expectation", "unicode-math-parser-20"

      it_behaves_like "shared parser constructor expectation", "unicode-math-parser-31"

      it_behaves_like "shared parser constructor expectation", "unicode-math-parser-42"

      context "when locale uses comma as the decimal separator" do
        around do |example|
          Plurimath.with_configuration do |config|
            config.locale = :fr
            example.run
          end
        end

        it_behaves_like "shared parser constructor expectation", "unicode-math-parser-61"
      end

      context "when locale uses Arabic decimal separator" do
        around do |example|
          Plurimath.with_configuration do |config|
            config.locale = :ar
            example.run
          end
        end

        it_behaves_like "shared parser constructor expectation", "unicode-math-parser-81"
      end
    end

    it_behaves_like "shared parser constructor expectation", "unicode-math-parser-94"

    it_behaves_like "shared parser constructor expectation", "unicode-math-parser-102"

    it_behaves_like "shared parser constructor expectation", "unicode-math-parser-110"

    it_behaves_like "shared parser constructor expectation", "unicode-math-parser-118"

    # Regression: "a" + combining circumflex + prime (U+0061 U+0302 U+2032)
    # reaches unicode_accents' prime branch. Before the fix the raw entity
    # string landed in the Power exponent and to_latex raised; now the prime
    # resolves to a Prime symbol and the conversion succeeds.
    it_behaves_like "shared parser constructor expectation", "unicode-math-parser-132-example-1"

    # Multi-prime: updated_primes maps each entity, so the exponent is a
    # Formula of Prime symbols rather than a raw string — guards the
    # Formula-exponent branch the fix introduces.
    it_behaves_like "shared parser constructor expectation", "unicode-math-parser-143-example-1"

    # Regression: "a" + combining tilde (U+0061 U+0303). The combining tilde
    # had no symbols_class mapping and leaked the raw "&#x303;" entity into the
    # accent slot; it now resolves to the Tilde symbol.
    it_behaves_like "shared parser constructor expectation", "unicode-math-parser-154-example-1"

    # Regression: a slash-prefixed prime (\prime, \pprime, ...) reaches the
    # prime handling as its bare name. Before the fix it resolved to nil,
    # leaving an empty exponent ("a^{}"); it now maps to the matching prime
    # symbol like the direct entity form does.
    it_behaves_like "shared parser constructor expectation", "unicode-math-parser-166-example-1"

    it_behaves_like "shared parser constructor expectation", "unicode-math-parser-174-example-1"

    it_behaves_like "shared parser constructor expectation", "unicode-math-parser-182-example-1"

    it_behaves_like "shared parser constructor expectation", "unicode-math-parser-190-example-1"
  end
end
