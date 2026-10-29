# frozen_string_literal: true

require "yaml"

module SharedGrammarFixtures
  FIXTURE_PATH = if RUBY_ENGINE == "opal"
                   File.expand_path("submodules/plurimath-testsuite/fixtures/grammar-expectations.yaml")
                 else
                   File.expand_path("../../submodules/plurimath-testsuite/fixtures/grammar-expectations.yaml", __dir__)
                 end
  CLASSES = {
    "latex" => "Plurimath::Latex::Parse",
    "html" => "Plurimath::Html::Parse",
    "unicode" => "Plurimath::UnicodeMath::Parse",
  }.freeze
  CASE_KEYS = %w[format id input label locale observations rule source transforms].freeze

  class Error < StandardError; end

  module_function

  def exact_keys!(value, keys)
    raise Error, "unexpected grammar fixture shape" unless value.is_a?(Hash) && value.keys.sort == keys.sort
  end

  def literal(value)
    if value.is_a?(Hash)
      exact_keys!(value, %w[symbol])
      raise Error, "invalid grammar symbol" unless value.fetch("symbol").is_a?(String)
      value.fetch("symbol").to_sym
    elsif value.is_a?(String)
      value.dup
    elsif value.nil? || value.is_a?(Integer)
      value
    else
      raise Error, "unsupported grammar literal"
    end
  end

  def validate_case!(row)
    exact_keys!(row, CASE_KEYS)
    unless CLASSES.key?(row["format"]) && row["id"].is_a?(String) &&
        row["input"].is_a?(String) && row["label"].is_a?(String) &&
        [nil, "en", "fr", "ar"].include?(row["locale"]) &&
        %w[expression number].include?(row["rule"])
      raise Error, "invalid grammar fixture metadata"
    end
    exact_keys!(row.fetch("source"), %w[path line])
    unless row["source"]["path"].is_a?(String) && row["source"]["line"].is_a?(Integer)
      raise Error, "invalid grammar fixture source"
    end
    unless row["transforms"].is_a?(Array) && row["observations"].is_a?(Array) && !row["observations"].empty?
      raise Error, "empty or invalid grammar operations"
    end
    unless row.fetch("observations").any? { |check| check.is_a?(Hash) && %w[eq nil parse_failure].include?(check["comparison"]) }
      raise Error, "grammar expectations need at least one comparison"
    end
    row.fetch("transforms").each do |step|
      case step["kind"]
      when "squeeze"
        exact_keys!(step, %w[kind value])
      when "replace"
        exact_keys!(step, %w[kind pattern value])
        pattern = step.fetch("pattern")
        case pattern["kind"]
        when "whitespace" then exact_keys!(pattern, %w[kind])
        when "literal"
          exact_keys!(pattern, %w[kind value])
          raise Error, "invalid replacement pattern" unless pattern["value"].is_a?(String)
        else raise Error, "unsupported grammar replacement"
        end
      else raise Error, "unsupported grammar input operation"
      end
      raise Error, "invalid grammar transform value" unless step["value"].is_a?(String)
    end
    row.fetch("observations").each do |check|
      case check["comparison"]
      when "parse_failure" then exact_keys!(check, %w[comparison])
      when "eq", "nil", "read"
        keys = check["comparison"] == "eq" ? %w[comparison expected path] : %w[comparison path]
        exact_keys!(check, keys)
        raise Error, "invalid grammar projection" unless check["path"].is_a?(Array)
        check.fetch("path").each do |key|
          if key.is_a?(Hash) && key.keys == ["operation"]
            raise Error, "unsupported grammar projection operation" unless key["operation"] == "first"
          else
            literal(key)
          end
        end
        literal(check.fetch("expected")) if check["comparison"] == "eq"
      else raise Error, "unsupported grammar comparison"
      end
    end
    if row["observations"].any? { |check| check["comparison"] == "parse_failure" } && row["observations"].length != 1
      raise Error, "refusal mixed with successful observations"
    end
  end

  def rows
    @rows ||= begin
      text = File.read(FIXTURE_PATH)
      data = RUBY_ENGINE == "opal" ? YAML.load(text) : YAML.safe_load(text) # rubocop:disable Security/YAMLLoad
      exact_keys!(data, %w[cases schema source])
      raise Error, "unsupported grammar fixture schema" unless data["schema"] == "plurimath-fixtures/grammar-expectations/1"
      source = data.fetch("source")
      exact_keys!(source, %w[files repository revision])
      unless source["repository"] == "https://github.com/plurimath/plurimath" &&
          source["revision"].is_a?(String) && /\A[0-9a-f]{40}\z/.match?(source["revision"]) &&
          source["files"].is_a?(Array) && !source["files"].empty?
        raise Error, "invalid grammar fixture provenance"
      end
      source.fetch("files").each do |file|
        exact_keys!(file, %w[path sha256])
        unless file["path"].is_a?(String) && file["sha256"].is_a?(String) &&
            /\A[0-9a-f]{64}\z/.match?(file["sha256"])
          raise Error, "invalid grammar source hash"
        end
      end
      raise Error, "empty grammar fixture dataset" unless data["cases"].is_a?(Array) && !data["cases"].empty?

      data.fetch("cases").each { |row| validate_case!(row) }
      index = data.fetch("cases").to_h { |row| [row.fetch("id"), row] }
      raise Error, "duplicate grammar fixture IDs" unless index.length == data.fetch("cases").length

      index
    end
  end

  def fetch(id)
    rows.fetch(id) { raise Error, "missing shared grammar fixture #{id}" }
  end

  def input(row)
    row.fetch("transforms").inject(row.fetch("input").dup) do |text, step|
      case step.fetch("kind")
      when "squeeze" then text.squeeze(step.fetch("value"))
      when "replace"
        pattern = step.fetch("pattern")
        text.gsub(pattern.fetch("kind") == "whitespace" ? /\s/ : pattern.fetch("value"), step.fetch("value"))
      else raise Error, "unsupported grammar input operation"
      end
    end
  end

  def project(tree, path)
    path.inject(tree) do |value, key|
      if key.is_a?(Hash) && key.keys == ["operation"]
        value.first
      else
        value[literal(key)]
      end
    end
  end

  def configured(row)
    if row["locale"]
      Plurimath.with_configuration do |config|
        config.locale = row.fetch("locale").to_sym
        yield
      end
    else
      yield
    end
  end
end
