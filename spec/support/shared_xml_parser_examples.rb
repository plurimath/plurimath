# frozen_string_literal: true

require_relative "shared_model_fixtures"

RSpec.shared_examples "shared XML parser models" do |payload, ids|
  if ids.empty? || ids.uniq.length != ids.length
    raise SharedModelFixtures::Error, "shared parser case IDs must be nonempty and unique"
  end

  ids.each do |id|
    it "parses #{payload}/#{id} into its recorded model" do
      input = SharedModelFixtures.input(payload, id)
      expected = SharedModelFixtures.model(payload, id, input: input)

      # Parse afresh on each engine run instead of reusing a memoized subject.
      expect(described_class.new(input).parse).to eq(expected)
    end
  end
end
