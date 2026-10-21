# frozen_string_literal: true

require "yaml"

# Expected objects for native parser specs. Keep the parser calls and the
# Ox/Oga/Opal examples; obtain their model data from the pinned shared corpus.
module SharedModelFixtures
  CORPUS_ROOT =
    if RUBY_ENGINE == "opal"
      # Opal records virtual require paths; its Node specs run in the checkout.
      File.expand_path("submodules/plurimath-testsuite/corpus")
    else
      File.expand_path("../../submodules/plurimath-testsuite/corpus", __dir__)
    end

  class Error < StandardError; end

  module_function

  def input(payload, id)
    case_data(payload, id).fetch("input").dup
  end

  def model(payload, id, input:)
    row = case_data(payload, id)
    unless row.fetch("input") == input
      raise Error, "shared model input differs for #{payload}/#{id}"
    end

    build(row.fetch("model"))
  end

  def case_data(payload, id)
    unless %r{\A(?:mathml|omml)/[a-z0-9-]+\z}.match?(payload)
      raise Error, "unsupported shared model payload #{payload.inspect}"
    end

    @payloads ||= {}
    data = @payloads[payload] ||= load_payload(payload)
    matches = data.fetch("cases").select { |row| row.fetch("id") == id }
    raise Error, "expected one shared model for #{payload}/#{id}" unless matches.length == 1

    row = matches.first
    unless row.fetch("input_format") == payload.split("/").first
      raise Error, "shared model format differs for #{payload}/#{id}"
    end

    row
  end

  def load_payload(payload)
    text = File.read(File.join(CORPUS_ROOT, "#{payload}.yaml"))
    # Opal's nodejs/yaml exposes load, implemented with js-yaml safeLoad.
    RUBY_ENGINE == "opal" ? YAML.load(text) : YAML.safe_load(text) # rubocop:disable Security/YAMLLoad
  end

  def build(value)
    case value
    when Array then value.map { |entry| build(entry) }
    when Hash
      return {} if value.empty?

      unless value.keys.sort == %w[class fields]
        raise Error, "unsupported shared model mapping"
      end

      name = value.fetch("class")
      unless /\AMath(?:::[A-Z]\w*)+\z/.match?(name) && name != "Math::Function::Unitsml"
        raise Error, "unsupported shared model class #{name.inspect}"
      end

      klass = name.split("::").inject(Plurimath) { |scope, part| scope.const_get(part, false) }
      raise Error, "shared model class must inherit Math::Core" unless klass < Plurimath::Math::Core

      # Constructors are the implementation under test, not the fixture
      # decoder. Assign recorded state without transforming it a second time.
      node = klass.allocate
      value.fetch("fields").each do |field, entry|
        unless /\A[a-z_]\w*\z/.match?(field) && node.respond_to?(field)
          raise Error, "unsupported shared model field #{name}.#{field}"
        end

        node.instance_variable_set("@#{field}", build(entry))
      end
      node
    when String then value.dup
    when Numeric, TrueClass, FalseClass, NilClass then value
    else raise Error, "unsupported shared model value #{value.class}"
    end
  end
end
