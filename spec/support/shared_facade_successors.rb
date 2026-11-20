# frozen_string_literal: true

# Explicit candidate contract, pinned by the testsuite gitlink. This proposal
# must remain draft until the owner approves the changed writer expectations.
module SharedFacadeSuccessors
  ROOT = File.expand_path("../../submodules/plurimath-testsuite", __dir__)
  PROFILES = %w[writer-fidelity-v1 writer-authored-v1].freeze
  require File.join(ROOT, "scripts/validate-facade-successors")

  module_function

  def data
    @data ||= begin
      cases = PROFILES.flat_map { |profile| FacadeSuccessors.load(ROOT, profile).fetch("cases") }
      sources = cases.map { |entry| entry.fetch("source").values_at("path", "id") }
      raise FacadeSuccessors::Error, "duplicate source across facade profiles" unless sources.uniq == sources

      { "cases" => cases }
    end
  end

  def select(path, rows)
    FacadeSuccessors.select(data, path, rows)
  end

  def row(path, original)
    entry = data.fetch("cases").find do |item|
      item.fetch("source").values_at("path", "id") == [path, original.fetch("id")]
    end
    entry ? FacadeSuccessors.apply(original, entry) : original
  end
end
