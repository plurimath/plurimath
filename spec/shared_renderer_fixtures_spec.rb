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
  it "repeats direct render calls while retaining an explicit source-let output" do
    model = Plurimath::Math::Number.new("12")
    expect(model).to receive(:to_latex).twice.and_return("first", "second")
    cache = {}
    direct = 2.times.map { described_class.render_model(model, operation, {}, example_memo: cache) }
    expect(direct).to eq(%w[first second])

    cached_model = Plurimath::Math::Number.new("12")
    expect(cached_model).to receive(:to_latex).once.and_return("cached")
    cached_operation = operation.merge("memo" => ["let:mathml"])
    values = 2.times.map { described_class.render_model(cached_model, cached_operation, {}, example_memo: cache) }
    expect(values).to eq(%w[cached cached])
    expect(values.first).to equal(values.last)
  end

  it "retains a parsed subject while direct renders run on each invocation" do
    row = { "program" => { "assertion_lines" => [1], "steps" => [
      { "kind" => "build", "save" => "v1", "recipe" => literal("12") },
      { "kind" => "decode", "source" => "v1", "save" => "v2", "boundary" => "wrapper", "format" => "latex", "memo" => { "ids" => ["let:formula"], "dependencies" => ["v1"] } },
      { "kind" => "render", "source" => "v2", "save" => "v3", "operation" => operation },
      { "kind" => "assert", "source" => "v3", "comparison" => "eq", "expected" => "12", "assertion_line" => 1 },
    ] } }
    model = Plurimath::Math::Number.new("12")
    expect(described_class).to receive(:decode).once.and_return(model)
    expect(model).to receive(:to_latex).twice.and_return("12")
    cache = {}
    2.times do
      described_class.run_program(row, example_memo: cache) { |actual, expected, _| expect(actual).to eq(expected) }
    end
  end

  it "shares typed source-let models but rebuilds locals and constants per invocation" do
    recipe = program_row.fetch("program").fetch("steps").first.fetch("recipe")
    cache = {}
    first = described_class.model_memo(cache)
    second = described_class.model_memo(cache)
    build = lambda do |scope, id|
      SharedModelRecipes.build({ "kind" => "memo", "id" => id, "value" => recipe }, scope)
    end
    expect(build.call(first, "let:formula")).to equal(build.call(second, "let:formula"))
    expect(build.call(first, "local:formula:1")).not_to equal(build.call(second, "local:formula:1"))
    expect(build.call(first, "constant:FORMULA")).not_to equal(build.call(second, "constant:FORMULA"))
    expect(build.call(first, "let:formula")).not_to equal(build.call(described_class.model_memo({}), "let:formula"))
  end

  it "retains source aliases and rejects conflicting memo definitions" do
    cache = {}
    definition = { "boundary" => "wrapper", "format" => "latex" }
    value = described_class.memoized(["let:formula", "let:alias"], definition, cache) { Object.new }
    expect(described_class.memoized(["let:alias"], definition, cache) { raise "alias was rebuilt" }).to equal(value)
    expect { described_class.memoized(["let:formula"], definition.merge("format" => "omml"), cache) {} }
      .to raise_error(described_class::Error, /conflicting source-let memo/)
    expect { described_class.validate_memo!(["local:formula:1"]) }
      .to raise_error(described_class::Error, /invalid source-let memo/)
  end

  it "skips an anonymous input constructor when its rendered source let is cached" do
    row = { "input" => { "kind" => "model", "recipe" => program_row.fetch("program").fetch("steps").first.fetch("recipe") },
      "operation" => operation.merge("memo" => ["let:mathml"]) }
    expect(Plurimath::Math::Number).to receive(:new).with("12").once.and_call_original
    cache = {}
    expect(2.times.map { described_class.render(row, example_memo: cache) }).to eq(%w[12 12])
  end

  it "skips cached let-body dependencies but repeats original local assignments" do
    row = program_row
    steps = row.fetch("program").fetch("steps")
    steps[1]["memo"] = { "ids" => ["let:mathml"], "dependencies" => ["v1"] }
    local_recipe = { "kind" => "constructor", "class" => "Math::Number", "args" => [literal("99")], "kwargs" => { "kind" => "map", "entries" => [] } }
    steps.unshift({ "kind" => "build", "save" => "v4", "recipe" => local_recipe })
    expect(Plurimath::Math::Number).to receive(:new).with("12").once.and_call_original
    expect(Plurimath::Math::Number).to receive(:new).with("99").twice.and_call_original
    cache = {}
    2.times { described_class.run_program(row, example_memo: cache) { |actual, expected, _| expect(actual).to eq(expected) } }
  end

end
