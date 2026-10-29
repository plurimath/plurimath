# frozen_string_literal: true

require "spec_helper"
require_relative "support/shared_facade_fixtures"

RSpec.describe SharedFacadeFixtures do
  def facade_row(steps)
    { "configuration" => {}, "program" => { "steps" => steps } }
  end

  def build_step(slot, value)
    { "kind" => "build", "save" => slot,
      "recipe" => { "kind" => "literal", "value" => value } }
  end

  it "rejects empty programs and programs containing only construction" do
    [[], [build_step("v1", "x")]].each do |steps|
      expect { described_class.run(facade_row(steps), nil) {} }
        .to raise_error(SharedFacadeFixtures::Error, /meaningful observation/)
    end
  end

  it "rejects missing observations before dispatching a constructor" do
    construction = { "kind" => "build", "save" => "v1",
                     "recipe" => { "kind" => "unrecognized" } }
    expect { described_class.run(facade_row([construction]), nil) {} }
      .to raise_error(SharedFacadeFixtures::Error, /meaningful observation/)
  end

  it "validates observation fields before accepting a check" do
    malformed = { "kind" => "assert", "source" => "v1",
                  "comparison" => "unrecognized", "assertion_line" => 1 }
    expect { described_class.run(facade_row([malformed]), nil) {} }
      .to raise_error(SharedFacadeFixtures::Error, /unsupported facade comparison/)
  end

  it "dispatches an existing assertion with its actual and expected values" do
    assertion = { "kind" => "assert", "source" => "v1", "expected_slot" => "v2",
                  "comparison" => "eq", "assertion_line" => 1 }
    row = facade_row([build_step("v1", "x"), build_step("v2", "x"), assertion])
    checks = []
    described_class.run(row, nil) { |step, actual, expected| checks << [step, actual, expected] }
    expect(checks).to eq([[assertion, "x", "x"]])
  end

  it "dispatches an existing no-error observation and executes its operation" do
    observation = { "kind" => "facade_no_error", "assertion_line" => 1,
                    "steps" => [build_step("v1", "x")] }
    checks = []
    described_class.run(facade_row([observation]), nil) do |step, operation, expected|
      checks << [step.fetch("kind"), operation.call, expected]
    end
    expect(checks).to eq([["facade_no_error", { "v1" => "x" }, nil]])
  end
end
