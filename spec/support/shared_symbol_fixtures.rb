# frozen_string_literal: true

require "yaml"

module SharedSymbolFixtures
  SCHEMA = "plurimath-fixtures/symbol-renderings/1"
  TARGETS = %w[asciimath latex unicodemath omml mathml html].freeze
  FIXTURE_PATH =
    if RUBY_ENGINE == "opal"
      File.expand_path("submodules/plurimath-testsuite/fixtures/symbol-renderings.yaml")
    else
      File.expand_path("../../submodules/plurimath-testsuite/fixtures/symbol-renderings.yaml", __dir__)
    end

  class Error < StandardError; end

  module_function

  def fetch(id, klass)
    @datasets ||= {}
    rows = @datasets[FIXTURE_PATH] ||= load_fixture(FIXTURE_PATH).fetch("cases").to_h do |entry|
      [entry.fetch("id"), entry]
    end
    row = rows[id]
    raise Error, "missing shared symbol #{id.inspect}" unless row
    unless klass.name == "Plurimath::#{row.fetch('class')}"
      raise Error, "shared symbol class differs for #{id.inspect}"
    end

    copy(row)
  end

  def load_fixture(path)
    text = File.read(path)
    # Opal's nodejs/yaml exposes load, implemented with js-yaml safeLoad.
    data = RUBY_ENGINE == "opal" ? YAML.load(text) : YAML.safe_load(text) # rubocop:disable Security/YAMLLoad
    validate(data)
    data
  end

  def exact_keys?(value, keys)
    value.is_a?(Hash) && value.keys.all? { |key| key.is_a?(String) } && value.keys.sort == keys.sort
  end

  def validate(data)
    unless exact_keys?(data, %w[schema provenance targets cases]) && data["schema"] == SCHEMA &&
        data["targets"] == TARGETS && data["cases"].is_a?(Array) && !data["cases"].empty?
      raise Error, "unsupported or empty shared symbol fixture"
    end

    provenance = data["provenance"]
    unless exact_keys?(provenance, %w[repository ruby_commit]) &&
        provenance["repository"] == "https://github.com/plurimath/plurimath" &&
        provenance["ruby_commit"].is_a?(String) && /\A[0-9a-f]{40}\z/.match?(provenance["ruby_commit"])
      raise Error, "unsupported shared symbol provenance"
    end

    data["cases"].each { |row| validate_case(row) }
    %w[id class].each do |key|
      values = data["cases"].map { |row| row.fetch(key) }
      raise Error, "duplicate shared symbol #{key}" unless values.uniq.length == values.length
    end
  end

  def validate_case(row)
    unless exact_keys?(row, %w[id class mathml_intent asciimath_explicit_empty_options expected source]) &&
        row["id"].is_a?(String) && /\A[a-z0-9_]+\z/.match?(row["id"]) &&
        row["class"].is_a?(String) && /\AMath::Symbols::[A-Z]\w*\z/.match?(row["class"]) &&
        [true, false].include?(row["mathml_intent"]) &&
        [true, false].include?(row["asciimath_explicit_empty_options"]) &&
        exact_keys?(row["expected"], TARGETS) && row["expected"].values.all? { |value| value.is_a?(String) }
      raise Error, "unsupported shared symbol case"
    end

    source = row["source"]
    unless exact_keys?(source, %w[path sha256]) &&
        source["path"] == "spec/plurimath/math/symbols/#{row['id']}_spec.rb" &&
        source["sha256"].is_a?(String) && /\A[0-9a-f]{64}\z/.match?(source["sha256"])
      raise Error, "unsupported shared symbol source"
    end
  end

  def copy(value)
    case value
    when Hash then value.to_h { |key, entry| [key.dup, copy(entry)] }
    when Array then value.map { |entry| copy(entry) }
    when String then value.dup
    else value
    end
  end
end
