# frozen_string_literal: true

require "spec_helper"
require "support/shared_renderer_fixtures"

RSpec.describe SharedRendererFixtures do
  def literal(value)
    { "kind" => "literal", "value" => value }
  end

  def operation
    { "method" => "to_latex", "args" => [], "kwargs" => { "kind" => "map", "entries" => [
      { "key" => { "kind" => "symbol", "value" => "options" }, "value" => { "kind" => "map", "entries" => [] } },
    ] }, "normalizations" => [] }
  end

  def program_row
    { "program" => { "assertion_lines" => [1], "steps" => [
      { "kind" => "build", "save" => "v1", "recipe" => {
        "kind" => "constructor", "class" => "Math::Number", "args" => [literal("12")],
        "kwargs" => { "kind" => "map", "entries" => [] },
      } },
      { "kind" => "render", "save" => "v2", "source" => "v1", "operation" => operation },
      { "kind" => "assert", "source" => "v2", "comparison" => "eq", "expected" => "12", "assertion_line" => 1 },
    ] } }
  end

  it "executes valid model, render, transform and expected-slot assertions in order" do
    row = program_row
    row.fetch("program")["aggregate_failures"] = true
    steps = row.fetch("program").fetch("steps")
    steps.insert(2, { "kind" => "transform", "source" => "v2", "save" => "v3", "normalization" => "strip" })
    steps.last.delete("expected")
    steps.last["expected_slot"] = "v3"
    checks = []
    described_class.run_program(row) { |*check| checks << check }
    expect(checks).to eq([["12", "12", "eq"]])
  end

  it "accepts the closed decode and observation branches" do
    row = { "program" => { "assertion_lines" => [1], "no_error" => true, "steps" => [
      { "kind" => "build", "save" => "v1", "recipe" => literal("12") },
      { "kind" => "decode", "source" => "v1", "save" => "v2", "boundary" => "wrapper", "format" => "latex" },
      { "kind" => "observe", "source" => "v2", "save" => "v3", "observation" => "first_model_value" },
      { "kind" => "render", "source" => "v3", "save" => "v4", "operation" => operation },
      { "kind" => "assert", "source" => "v4", "comparison" => "eq", "expected" => "12", "assertion_line" => 1 },
    ] } }
    checks = []
    described_class.run_program(row) { |*check| checks << check }
    expect(checks).to eq([["12", "12", "eq"]])
  end

  it "restores configuration after a valid finite formatter step" do
    previous = Plurimath.configuration.number_formatter
    row = program_row
    row.fetch("program").fetch("steps").unshift({ "kind" => "configure_number_formatter", "recipe" => literal(nil) })
    described_class.run_program(row) { |actual, expected, _| expect(actual).to eq(expected) }
    expect(Plurimath.configuration.number_formatter).to equal(previous)
  end

  { "build" => 0, "render" => 1, "assert" => 2 }.each do |kind, index|
    it "rejects undeclared #{kind} fields before constructing or rendering anything" do
      row = program_row
      row.fetch("program").fetch("steps").fetch(index)["unsupported"] = "ignored before the guard"
      expect(SharedModelRecipes).not_to receive(:build)
      expect { described_class.run_program(row) {} }.to raise_error(described_class::Error, /unexpected renderer fields/)
    end
  end

  it "rejects undeclared operation fields before dispatch, including direct facade reuse" do
    model = Plurimath::Math::Number.new("12")
    invalid = operation.merge("unsupported" => "ignored before the guard")
    expect(model).not_to receive(:to_latex)
    expect { described_class.render_model(model, invalid, {}) }.to raise_error(described_class::Error, /unexpected renderer fields/)
    row = program_row
    row.fetch("program").fetch("steps")[1]["operation"] = invalid
    expect(SharedModelRecipes).not_to receive(:build)
    expect { described_class.run_program(row) {} }.to raise_error(described_class::Error, /unexpected renderer fields/)
  end

  it "rejects missing required fields and ambiguous assertions" do
    row = program_row
    row.fetch("program").fetch("steps").first.delete("save")
    expect { described_class.run_program(row) {} }.to raise_error(described_class::Error, /missing renderer fields/)
    row = program_row
    row.fetch("program").fetch("steps").last["expected_slot"] = "v2"
    expect { described_class.run_program(row) {} }.to raise_error(described_class::Error, /one expected value/)
  end

  it "rejects unknown program fields, invalid flags and missing source lines" do
    row = program_row
    row.fetch("program")["unsupported"] = true
    expect { described_class.run_program(row) {} }.to raise_error(described_class::Error, /unexpected renderer fields/)
    row = program_row
    row.fetch("program")["no_error"] = false
    expect { described_class.run_program(row) {} }.to raise_error(described_class::Error, /flag must be true/)
    row = program_row
    row.fetch("program").delete("assertion_lines")
    expect { described_class.run_program(row) {} }.to raise_error(described_class::Error, /missing renderer fields/)
  end

  it "requires an assertion unless the program explicitly checks no-error acceptance" do
    row = program_row
    row.fetch("program")["steps"] = [row.fetch("program").fetch("steps").first]
    expect { described_class.run_program(row) {} }.to raise_error(described_class::Error, /needs an assertion/)
    row.fetch("program")["no_error"] = false
    expect { described_class.run_program(row) {} }.to raise_error(described_class::Error, /flag must be true/)
    row.fetch("program")["no_error"] = true
    expect { described_class.run_program(row) { raise "unexpected assertion" } }.not_to raise_error
  end

  it "rejects invalid decode boundaries and argument fields before dispatch" do
    row = program_row
    steps = row.fetch("program").fetch("steps")
    steps[1] = { "kind" => "decode", "source" => "v1", "save" => "v2", "boundary" => "arbitrary_call", "format" => "latex" }
    expect(described_class).not_to receive(:decode)
    expect { described_class.run_program(row) {} }.to raise_error(described_class::Error, /decode boundary/)
    steps[1]["boundary"] = "wrapper"
    steps[1]["format_argument"] = literal("latex")
    expect { described_class.run_program(row) {} }.to raise_error(described_class::Error, /argument differs from boundary/)
  end
end
