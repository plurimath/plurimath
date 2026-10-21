# frozen_string_literal: true

require "support/shared_model_recipes"
require "yaml"

module SharedRendererFixtures
  METHODS = %w[to_asciimath to_latex to_html to_mathml to_omml to_unicodemath to_display to_mathml_without_math_tag to_omml_without_math_tag].freeze
  COMPARISONS = %w[eq eql not_eq not_eql match be_xml_equivalent_to be_empty not_be_nil include not_include start_with not_start_with end_with not_end_with model_class not_model_class text_kind].freeze
  STEP_FIELDS = {
    "build" => [%w[kind save recipe], []],
    "render" => [%w[kind save source operation], []],
    "decode" => [%w[kind save source boundary format], %w[format_argument]],
    "transform" => [%w[kind save source normalization], []],
    "observe" => [%w[kind save source observation], %w[arguments]],
    "configure_number_formatter" => [%w[kind recipe], []],
    "assert" => [%w[kind source comparison assertion_line], %w[expected expected_slot]],
  }.freeze
  NORMALIZATIONS = %w[remove_whitespace unescape_ampersand strip].freeze
  DUMPS = %w[xml_engine_indent_2 dump_ox_nodes].freeze
  OBSERVATIONS = %w[normalized_intents unitsml_presentation_spaced_identifiers unitsml_presentation_spacer_count unitsml_presentation_spacer_unique_text overset_display_base overset_display_script overset_inline_base overset_inline_script underset_display_base underset_display_script underset_inline_base underset_inline_script cancellation_box cancellation_root_child_count cancellation_child_names cancellation_property_names cancellation_property_values cancellation_content_text cancellation_nested_box_count cancellation_strike_count].freeze
  INTENT_REPLACEMENTS = [["$n)", "$naryand)"], ["𝐴", "A"], ["𝑎", "a"], ["𝛼", "a"], ["𝑏", "b"], ["𝑆", "S"], ["𝑛", "n"], ["𝑘", "k"], ["𝑡", "t"], ["𝑥", "x"], ["𝑦", "y"], ["𝑁", "N"], ["α", "a"], ["𝜋", "π"]].freeze
  ROOT = if RUBY_ENGINE == "opal"
           File.expand_path("submodules/plurimath-testsuite/fixtures")
         else
           File.expand_path("../../submodules/plurimath-testsuite/fixtures", __dir__)
         end
  class Error < StandardError; end

  module_function

  def fields!(record, required, optional = [])
    raise Error, "renderer record must be a mapping" unless record.is_a?(Hash)
    raise Error, "missing renderer fields" unless (required - record.keys).empty?
    raise Error, "unexpected renderer fields" unless (record.keys - required - optional).empty?
  end

  def validate_operation!(operation)
    fields!(operation, %w[method args kwargs normalizations], %w[observation dump roundtrip])
    raise Error, "unsupported renderer operation" unless METHODS.include?(operation.fetch("method"))
    raise Error, "renderer arguments must be an array" unless operation.fetch("args").is_a?(Array)
    raise Error, "renderer kwargs must be a typed map" unless operation.fetch("kwargs").is_a?(Hash) && operation.fetch("kwargs")["kind"] == "map"
    normalizations = operation.fetch("normalizations")
    raise Error, "unsupported renderer normalizations" unless normalizations.is_a?(Array) && (normalizations - NORMALIZATIONS).empty?
    raise Error, "unsupported renderer dump" if operation.key?("dump") && !DUMPS.include?(operation.fetch("dump"))
    raise Error, "unsupported renderer roundtrip" if operation.key?("roundtrip") && operation.fetch("roundtrip") != "omml"
    raise Error, "unsupported renderer observation" if operation.key?("observation") && !OBSERVATIONS.include?(operation.fetch("observation"))
  end

  def validate_program!(program)
    fields!(program, %w[steps assertion_lines], %w[no_error aggregate_failures])
    %w[no_error aggregate_failures].each do |flag|
      raise Error, "renderer program flag must be true" if program.key?(flag) && program.fetch(flag) != true
    end
    lines = program.fetch("assertion_lines")
    raise Error, "renderer assertion lines must be positive integers" unless lines.is_a?(Array) && !lines.empty? && lines.all? { |line| line.is_a?(Integer) && line.positive? }
    steps = program.fetch("steps")
    raise Error, "renderer steps must be a nonempty array" unless steps.is_a?(Array) && !steps.empty?

    # Check the entire boundary before any model construction, rendering or
    # configuration changes, including invalid fields on later assertions.
    steps.each { |step| validate_step!(step) }
    unless steps.any? { |step| step.fetch("kind") == "assert" } || program["no_error"] == true
      raise Error, "renderer program needs an assertion or explicit no-error acceptance"
    end
  end

  def validate_step!(step)
    raise Error, "renderer step must be a mapping" unless step.is_a?(Hash)
    required, optional = STEP_FIELDS.fetch(step["kind"]) { raise Error, "unsupported renderer sequence step" }
    fields!(step, required, optional)
    %w[save source expected_slot].each do |field|
      next unless step.key?(field)

      raise Error, "invalid renderer slot" unless step.fetch(field).is_a?(String) && step.fetch(field).match?(/\Av[1-9][0-9]*\z/)
    end
    case step.fetch("kind")
    when "render" then validate_operation!(step.fetch("operation"))
    when "decode"
      boundary = step.fetch("boundary")
      formats = { "html_parser" => "html", "asciimath_parser" => "asciimath", "mathml_utility_helper" => "mathml", "omml_utility_helper" => "omml" }
      raise Error, "unsupported sequence decode boundary" unless %w[math_parse wrapper].include?(boundary) || formats.key?(boundary)
      raise Error, "unsupported sequence decode format" unless %w[asciimath latex mathml omml unicode html].include?(step.fetch("format"))
      raise Error, "sequence decode boundary format differs" if formats.key?(boundary) && formats.fetch(boundary) != step.fetch("format")
      raise Error, "sequence format argument differs from boundary" unless step.key?("format_argument") == (boundary == "math_parse")
    when "transform"
      raise Error, "unsupported sequence transform" unless (NORMALIZATIONS + DUMPS + ["first_fragment_node"]).include?(step.fetch("normalization"))
    when "observe"
      observation = step.fetch("observation")
      raise Error, "unsupported renderer observation" unless (OBSERVATIONS + %w[first_model_value display_tail_labels mathml_token_pairs spaced_token_property omml_operand_text]).include?(observation)
      if step.key?("arguments")
        arguments = step.fetch("arguments")
        fields!(arguments, [], %w[scope field])
        raise Error, "renderer observation needs one argument" unless arguments.length == 1
        raise Error, "unsupported observation scope" if arguments.key?("scope") && !%w[all munderover_children].include?(arguments.fetch("scope"))
        raise Error, "unsupported observation field" if arguments.key?("field") && !%w[name rspace text accent_base accent_script lower upper base split_hat_bases].include?(arguments.fetch("field"))
      end
      argument = observation == "mathml_token_pairs" ? "scope" : ("field" if %w[spaced_token_property omml_operand_text].include?(observation))
      raise Error, "missing renderer observation argument" if argument && !step.fetch("arguments", {}).key?(argument)
    when "assert"
      raise Error, "unsupported renderer comparison" unless COMPARISONS.include?(step.fetch("comparison"))
      raise Error, "renderer assertion needs one expected value" unless step.key?("expected") != step.key?("expected_slot")
      line = step.fetch("assertion_line")
      raise Error, "invalid renderer assertion line" unless line.is_a?(Integer) && line.positive?
      if step.fetch("comparison") == "text_kind" && step["expected"] != "text"
        raise Error, "text-kind observation must expect text"
      end
    end
  end

  def rows
    @rows ||= begin
      text = File.read(File.join(ROOT, "renderer-expectations.yaml"))
      # Opal exposes YAML.load; MRI also supports the safe_load API.
      data = RUBY_ENGINE == "opal" ? YAML.load(text) : YAML.safe_load(text) # rubocop:disable Security/YAMLLoad
      raise Error, "unsupported renderer fixture schema" unless data.fetch("schema") == "plurimath-fixtures/renderer-expectations/1"

      cases = data.fetch("cases")
      ids = cases.map { |row| row.fetch("id") }
      raise Error, "renderer fixture IDs must be unique and nonempty" if ids.empty? || ids.uniq.length != ids.length

      cases
    end
  end

  def row(id)
    matches = rows.select { |entry| entry.fetch("id") == id }
    raise Error, "unknown renderer fixture #{id.inspect}" unless matches.length == 1

    matches.first
  end

  def render(row)
    memo = {}
    input = row.fetch("input")
    model = case input.fetch("kind")
            when "model" then SharedModelRecipes.build(input.fetch("recipe"), memo)
            when "parse"
              format = input.fetch("format")
              raise Error, "unsupported parser format" unless %w[asciimath latex mathml omml unicode html].include?(format)

              Plurimath::Math.parse(input.fetch("text").dup, format.to_sym)
            else raise Error, "unsupported renderer input"
            end
    render_model(model, row.fetch("operation"), memo)
  end

  def render_model(model, operation, memo)
    validate_operation!(operation)
    raise Error, "renderer input must be a Math::Core node" unless model.is_a?(Plurimath::Math::Core)

    method = operation.fetch("method")
    raise Error, "unsupported renderer operation" unless METHODS.include?(method)

    args = operation.fetch("args").map { |recipe| SharedModelRecipes.build(recipe, memo) }
    kwargs = SharedModelRecipes.build(operation.fetch("kwargs"), memo)
    actual = kwargs.empty? ? model.public_send(method, *args) : model.public_send(method, *args, **kwargs)
    if operation.key?("roundtrip")
      raise Error, "unsupported renderer roundtrip" unless operation.fetch("roundtrip") == "omml"

      return { actual: Plurimath::Omml.new(actual).to_formula, expected: model }
    end
    case operation["dump"]
    when nil
    when "xml_engine_indent_2" then actual = Plurimath.xml_engine.dump(actual, indent: 2)
    when "dump_ox_nodes" then actual = Plurimath::Math::Core.new.dump_ox_nodes(actual)
    else raise Error, "unsupported renderer dump"
    end
    operation.fetch("normalizations").each do |normalization|
      actual = case normalization
               when "remove_whitespace" then actual.gsub(/\s/, "")
               when "unescape_ampersand" then actual.gsub("&amp;", "&")
               when "strip" then actual.strip
               else raise Error, "unsupported renderer normalization"
               end
    end
    observe(actual, operation["observation"])
  end

  def run_program(row, context: nil)
    program = row.fetch("program")
    validate_program!(program)
    memo = {}
    slots = {}
    steps = program.fetch("steps")
    configured_formatter = steps.any? { |step| step.fetch("kind") == "configure_number_formatter" }
    previous_formatter = Plurimath.configuration.number_formatter if configured_formatter
    steps.each do |step|
      actual = case step.fetch("kind")
               when "build" then SharedModelRecipes.build(step.fetch("recipe"), memo)
               when "render" then render_model(slots.fetch(step.fetch("source")), step.fetch("operation"), memo)
               when "decode" then decode(slots.fetch(step.fetch("source")), step, memo, context: context)
               when "transform" then transform(slots.fetch(step.fetch("source")), step.fetch("normalization"))
               when "observe" then observe(slots.fetch(step.fetch("source")), step.fetch("observation"), step.fetch("arguments", {}))
               when "configure_number_formatter"
                 formatter = SharedModelRecipes.build(step.fetch("recipe"), memo)
                 unless formatter.nil? || formatter.instance_of?(Plurimath::Formatter::Standard) || formatter.instance_of?(Plurimath::NumberFormatter)
                   raise Error, "sequence formatter must use a closed standard formatter recipe"
                 end
                 Plurimath.configuration.number_formatter = formatter
               when "assert"
                 expected = step.key?("expected_slot") ? slots.fetch(step.fetch("expected_slot")) : step.fetch("expected")
                 yield slots.fetch(step.fetch("source")), expected, step.fetch("comparison")
                 nil
               else raise Error, "unsupported renderer sequence step"
               end
      if step["save"]
        raise Error, "renderer sequence slot reused" if slots.key?(step.fetch("save"))

        slots[step.fetch("save")] = actual
      end
    end
  ensure
    Plurimath.configuration.number_formatter = previous_formatter if configured_formatter
  end

  def decode(text, step, memo, context: nil)
    raise Error, "renderer decode input must be text" unless text.is_a?(String)

    format = step.fetch("format")
    raise Error, "unsupported sequence decode format" unless %w[asciimath latex mathml omml unicode html].include?(format)

    case step.fetch("boundary")
    when "math_parse"
      argument = SharedModelRecipes.build(step.fetch("format_argument"), memo)
      raise Error, "sequence format argument differs" unless [String, Symbol].any? { |type| argument.is_a?(type) } && argument.to_s == format

      Plurimath::Math.parse(text, argument)
    when "wrapper"
      klass = case format
              when "asciimath" then Plurimath::Asciimath
              when "latex" then Plurimath::Latex
              when "mathml" then Plurimath::Mathml
              when "omml" then Plurimath::Omml
              when "unicode" then Plurimath::UnicodeMath
              when "html" then Plurimath::Html
              end
      klass.new(text).to_formula
    when "html_parser"
      raise Error, "HTML parser format differs" unless format == "html"

      Plurimath::Html::Parser.new(text).parse
    when "asciimath_parser"
      raise Error, "AsciiMath parser format differs" unless format == "asciimath"

      Plurimath::Asciimath::Parser.new(text).parse
    when "mathml_utility_helper"
      raise Error, "MathML utility helper context differs" unless format == "mathml" && context

      context.parse_mathml(text)
    when "omml_utility_helper"
      raise Error, "OMML utility helper context differs" unless format == "omml" && context

      context.parse_omml(text)
    else raise Error, "unsupported sequence decode boundary"
    end
  end

  def transform(actual, normalization)
    case normalization
    when "remove_whitespace" then actual.gsub(/\s/, "")
    when "unescape_ampersand" then actual.gsub("&amp;", "&")
    when "strip" then actual.strip
    when "dump_ox_nodes" then Plurimath::Math::Core.new.dump_ox_nodes(actual)
    when "xml_engine_indent_2" then Plurimath.xml_engine.dump(actual, indent: 2)
    when "first_fragment_node" then actual.first
    else raise Error, "unsupported sequence transform"
    end
  end

  def observe(actual, observation, arguments = {})
    return actual unless observation

    return actual.value.first if observation == "first_model_value"
    return actual.lines.last(2).map(&:strip) if observation == "display_tail_labels"

    if observation == "mathml_token_pairs"
      raise Error, "unsupported token observation arguments" unless arguments.keys == ["scope"]

      document = Oga.parse_xml(actual)
      nodes = case arguments.fetch("scope")
              when "all" then document.xpath("//*").select { |node| node.name.match?(/\Am[io]\z/) }
              when "munderover_children"
                document.xpath("//*").find { |node| node.name == "munderover" }.children.grep(Oga::XML::Element)
              else raise Error, "unsupported MathML token scope"
              end
      return nodes.map { |node| [node.name, node.text] }
    end
    if observation == "spaced_token_property"
      raise Error, "unsupported spaced token arguments" unless arguments.keys == ["field"]

      token = Oga.parse_xml(actual).xpath("//*[@rspace]").first
      case arguments.fetch("field")
      when "name" then return token&.name
      when "rspace" then return token&.get("rspace")
      when "text" then return token&.text
      else raise Error, "unsupported spaced token field"
      end
    end
    if observation == "omml_operand_text"
      raise Error, "unsupported OMML operand arguments" unless arguments.keys == ["field"]

      document = Oga.parse_xml(actual)
      namespace = { "m" => "http://schemas.openxmlformats.org/officeDocument/2006/math" }
      if arguments.fetch("field") == "split_hat_bases"
        return document.xpath("//m:limUpp/m:e", namespaces: namespace).map do |base|
          base.xpath(".//m:t", namespaces: namespace).map(&:text).join
        end
      end
      path = case arguments.fetch("field")
             when "accent_base" then "//m:limUpp/m:e//m:t | //m:limLow/m:e//m:t"
             when "accent_script" then "//m:limUpp/m:lim//m:t | //m:limLow/m:lim//m:t"
             when "lower" then "//m:limLow/m:lim//m:t"
             when "upper" then "//m:limLow/m:e/m:limUpp/m:lim//m:t"
             when "base" then "//m:limLow/m:e/m:limUpp/m:e//m:t"
             else raise Error, "unsupported OMML operand field"
             end
      return document.xpath(path, namespaces: namespace).map(&:text).join
    end

    if observation == "normalized_intents"
      result = actual.scan(/intent="([^"]+)"/).sort.join
      INTENT_REPLACEMENTS.each { |from, to| result = result.gsub(from, to) }
      return result
    end
    if %w[overset_display_base overset_display_script overset_inline_base overset_inline_script underset_display_base underset_display_script underset_inline_base underset_inline_script].include?(observation)
      kind, display, field = observation.split("_")
      object_tag = if display == "display"
                     kind == "overset" ? "limUpp" : "limLow"
                   else
                     kind == "overset" ? "sSup" : "sSub"
                   end
      script_tag = display == "display" ? "lim" : (kind == "overset" ? "sup" : "sub")
      namespace = { "m" => "http://schemas.openxmlformats.org/officeDocument/2006/math" }
      object = Oga.parse_xml(actual).at_xpath("//m:#{object_tag}", namespaces: namespace)
      return object.at_xpath("m:#{field == 'base' ? 'e' : script_tag}", namespaces: namespace).text.strip
    end
    if %w[cancellation_box cancellation_root_child_count cancellation_child_names cancellation_property_names cancellation_property_values cancellation_content_text cancellation_nested_box_count cancellation_strike_count].include?(observation)
      namespace = { "m" => "http://schemas.openxmlformats.org/officeDocument/2006/math" }
      document = Oga.parse_xml("<root xmlns:m='#{namespace['m']}'>#{actual}</root>")
      box = document.at_xpath("/root/m:borderBox", namespaces: namespace)
      case observation
      when "cancellation_box" then return box
      when "cancellation_root_child_count" then return document.at_xpath("/root").xpath("*").length
      when "cancellation_child_names" then return box.xpath("*").map(&:name)
      when "cancellation_content_text" then return box.xpath("m:e//m:t", namespaces: namespace).map(&:text)
      when "cancellation_nested_box_count" then return document.xpath("/root/m:borderBox/m:e/m:borderBox", namespaces: namespace).length
      when "cancellation_strike_count" then return document.xpath("//m:strikeBLTR", namespaces: namespace).length
      end
      properties = box.at_xpath("m:borderBoxPr", namespaces: namespace).xpath("*")
      return properties.map(&:name) if observation == "cancellation_property_names"

      return properties.map { |property| property.xpath("@m:val", namespaces: namespace).first.value }
    end
    unless %w[unitsml_presentation_spaced_identifiers unitsml_presentation_spacer_count unitsml_presentation_spacer_unique_text].include?(observation)
      raise Error, "unsupported renderer observation"
    end

    doc = Oga.parse_xml(actual)
    doc.xpath("//*").select do |node|
      node.namespace&.uri == "https://schema.unitsml.org/unitsml/1.0"
    end.each(&:remove)
    if observation == "unitsml_presentation_spaced_identifiers"
      return doc.xpath("//*").select { |node| node.name == "mi" && node.get("rspace") }
    end

    spacers = doc.xpath("//*").select do |node|
      node.name == "mo" && node.get("rspace") == "thickmathspace"
    end
    observation == "unitsml_presentation_spacer_count" ? spacers.size : spacers.map(&:text).uniq
  end
end
