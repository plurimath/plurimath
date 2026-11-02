# frozen_string_literal: true

require "yaml"

module SharedCliFixtures
  ROOT = if RUBY_ENGINE == "opal"
           File.expand_path("submodules/plurimath-testsuite")
         else
           File.expand_path("../../submodules/plurimath-testsuite", __dir__)
         end
  module_function

  def fetch(id)
    @cases ||= begin
      payload = YAML.safe_load(File.read(File.join(ROOT, "fixtures/cli-conversions.yaml")))
      unless payload.is_a?(Hash) && payload["schema"] == "plurimath-fixtures/cli-conversions/1" &&
          payload["cases"].is_a?(Array) && !payload["cases"].empty?
        raise ArgumentError, "invalid shared CLI conversions"
      end
      rows = payload.fetch("cases")
      ids = rows.map { |row| row.fetch("id") }
      raise ArgumentError, "duplicate shared CLI IDs" unless ids.uniq.length == ids.length

      rows
    end
    rows = @cases.select { |row| row.fetch("id") == id }
    raise ArgumentError, "missing shared CLI conversion #{id}" unless rows.one?

    rows.first
  end
end

RSpec.shared_examples "shared CLI conversion" do |id|
  it "converts shared CLI input #{id}" do
    row = SharedCliFixtures.fetch(id)
    if row.key?("input_file")
      file = row.fetch("input_file")
      expect(File.read(file.fetch("path"))).to eq(file.fetch("content"))
    end
    arguments = row.fetch("arguments").map(&:dup)
    expect { described_class.start(arguments) }.to output(row.fetch("stdout")).to_stdout
  end
end
