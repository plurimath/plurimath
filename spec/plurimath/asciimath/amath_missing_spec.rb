# frozen_string_literal: true

require "spec_helper"

# Without the amath gem, AsciiMath parsing raises an error that names the
# missing gem and the fix, not a NameError or the generic parse message.
RSpec.describe Plurimath::Asciimath::Parse do
  let(:parse) { described_class.new }
  let(:message) do
    "[plurimath] AsciiMath parsing needs the amath gem, which could not be " \
      "loaded; add gem \"amath\" to your " \
      "Gemfile and run `bundle install`."
  end

  # amath is already loaded in the suite: hide the constant and make
  # `require "amath"` fail as it does when the gem is not installed.
  before do
    hide_const("Amath")
    allow(parse).to receive(:require).with("amath")
      .and_raise(LoadError, "cannot load such file -- amath")
    allow(described_class).to receive(:new).and_return(parse)
  end

  it "raises MissingDependencyError from Parse#parse" do
    expect { parse.parse("k") }
      .to raise_error(Plurimath::Math::MissingDependencyError, message)
  end

  it "passes the error through Math.parse unchanged" do
    expect { Plurimath::Math.parse("k", :asciimath) }
      .to raise_error(Plurimath::Math::MissingDependencyError, message)
  end

  it "is still a Math::ParseError" do
    expect { Plurimath::Math.parse("k", :asciimath) }
      .to raise_error(Plurimath::Math::ParseError)
  end

  it "re-raises a LoadError for another file unchanged" do
    allow(parse).to receive(:require).with("amath")
      .and_raise(LoadError, "cannot load such file -- parsanol")
    expect { parse.parse("k") }
      .to raise_error(LoadError, "cannot load such file -- parsanol")
  end
end
