# frozen_string_literal: true

# Explicit candidate contract, pinned by the testsuite gitlink. This proposal
# must remain draft until the owner approves the changed writer expectations.
module SharedFacadeSuccessors
  ROOT = File.expand_path("../../submodules/plurimath-testsuite", __dir__)
  PROFILE = "writer-fidelity-v1"
  require File.join(ROOT, "scripts/validate-facade-successors")

  module_function

  def data
    @data ||= FacadeSuccessors.load(ROOT, PROFILE)
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
