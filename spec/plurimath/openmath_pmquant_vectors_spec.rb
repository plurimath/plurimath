# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Openmath::Evaluation do
  fixture = JSON.parse(File.read(File.expand_path("../fixtures/evaluation/openmath-pmquant.json", __dir__)))

  # This is a test projection of existing Result fields, not a public wire
  # format. Checking both the class and text catches Float contamination.
  def exact_field(value)
    return nil if value.nil?
    return value.to_s if value.is_a?(Symbol) || value.is_a?(String)

    { "class" => value.class.name, "text" => value.to_s }
  end

  [2, 3].each do |version|
    fixture.fetch("cases").each do |row|
      it "replays #{row.fetch('id')} in OpenMath #{version}" do
        formula = Plurimath::Math.parse(row.fetch("request"), :openmath, version: version)
        bindings = row.fetch("bindings", {})
        if row.key?("refusal")
          refusal = row.fetch("refusal")
          expect { formula.evaluate(bindings) }.to raise_error do |error|
            expect(error.class.name).to eq(refusal.fetch("class"))
            expect(error.message).to eq(refusal.fetch("message"))
          end
        else
          result = formula.evaluate(bindings)
          expected = row.fetch("expected")
          expect(exact_field(result.value)).to eq(expected.fetch("value"))
          if expected.fetch("quantity")
            expect(result.quantity).to be_a(Openmath::Evaluation::Uncertain)
            expected.fetch("quantity").each do |field, value|
              expect(exact_field(result.quantity.public_send(field))).to eq(value)
            end
          else
            expect(result.quantity).to be_nil
          end
        end
      end
    end
  end
end
