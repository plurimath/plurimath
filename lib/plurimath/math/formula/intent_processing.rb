# frozen_string_literal: true

module Plurimath
  module Math
    class Formula
      # Optional MathML intent post-processing, loaded on first intent use.
      # @api private
      module IntentProcessing
        protected

        def intent_attribute(mathml)
          return unless mathml || value.length != 2
          return unless valid_first_parameter?(value.first)

          { intent: ":function" }
        end

        def valid_first_parameter?(param)
          undef_functions = UnicodeMath::Constants::UNDEF_UNARY_FUNCTIONS
          return true if param.is_a?(Symbols::Symbol) && undef_functions.include?(param.value)
          return false unless POWER_BASE_CLASSES.include?(param.class_name)

          param.parameter_one.is_a?(Function::UnaryFunction) ||
            param.parameter_one.is_a?(Function::Lim)
        end

        def intent_post_processing(nodes, _intent)
          mrow = XmlHelper.update_nodes(ox_element("mrow"), nodes)
          upcase_dd_derivative(nodes) if validate_upcase_dd_derivatives?(nodes)
          subsup_dd_derivative(nodes) if validate_subsup_dd_derivatives?(nodes)
          partial_derivative(nodes) if valid_partial_derivative?(nodes)
          update_partial_derivative_nodes(nodes) unless mrow.locate("*/mfrac/@arg").empty?
        end

        # Partial derivative nodes begin
        def update_partial_derivative_nodes(nodes)
          nodes.reduce do |first, second|
            if valid_partial_node(first)
              if %w[mfrac mo].include?(second.name)
                first["intent"] = first["intent"].gsub("$f", "")
              else
                second["arg"] = "f"
              end
            end
            second
          end
        end

        def valid_partial_node(node)
          return unless node.name == "mfrac"

          node["intent"]&.start_with?(":partial-derivative") &&
            !node.locate("*/@arg").include?("f")
        end

        def valid_partial_derivative?(nodes)
          valid = false
          nodes.reduce do |first, second|
            next second unless first.name == "msub"

            valid = true if first.nodes[0].nodes[0] == "&#x2202;" && second
            second
          end
          valid
        end

        def partial_derivative(nodes)
          nodes.each.with_index do |first, index|
            second = nodes[index + 1]
            next second unless first.name == "msub" && first.nodes.first.nodes.include?("&#x2202;")

            first["intent"] = partial_derivative_intent(first)
            f_arg(nodes, index + 1)
          end
        end

        def partial_derivative_intent(first)
          first_node = first.nodes.last
          case first_node.name
          when "mi"
            first_arg = 1
            second_arg = encode(first_node.nodes.first)
          when "mn"
            first_arg, second_arg = numeric_encoding(node)
          when "mrow"
            str = ""
            first_node.nodes.each do |node|
              case node.name
              when "mi"
                str += encode(node.nodes.first)
              when "mn"
                str += numeric_encoding(node).last if str.empty?
                break
              end
            end
            first_arg = str.include?(",") ? str.split(",").length : str.length
            second_arg = str.include?(",") ? str : str.chars.join(",")
          when "msup"
            nodes = first_node.nodes
            str = ""
            case nodes.first.name
            when "mrow"
              nodes.first.nodes.each do |node|
                case node.name
                when "mi"
                  str += encode(node.nodes.first)
                when "mn"
                  str += numeric_encoding(node).last if str.empty?
                  break
                end
              end
            when "mi"
              str += encode(node.nodes.first)
            end
            first_arg = str.include?(",") ? str.split(",").length : str.length
            second_arg = str.include?(",") ? str : str.chars.join(",")
            prime_str = encode(nodes.last.nodes.first) if valid_prime?(nodes.last)
            second_arg.insert(-1, prime_str) unless second_arg.match?(/[0-9]$/)
          end
          "#{intent_names[:partial_derivative]}(#{first_arg},$f,#{second_arg})"
        end

        def f_arg(tag_nodes, index)
          nodes = []
          while index <= tag_nodes.length
            node = tag_nodes[index]
            break unless node

            case node.name
            when "mrow"
              nodes << tag_nodes.delete_at(index)
              break
            when "mi"
              nodes << tag_nodes.delete_at(index)
            when "mn"
              nodes << tag_nodes.delete_at(index) if nodes.empty?
              break
            else
              break
            end
          end
          mrow = if nodes.length == 1
                   node = nodes.first
                   node["arg"] = "f"
                   node
                 else
                   XmlHelper.update_nodes(
                     ox_element("mrow", attributes: { arg: "f" }),
                     nodes,
                   )
                 end
          tag_nodes.insert(index, mrow)
        end
        # Partial derivative nodes end

        # Dd derivative nodes begin
        def validate_subsup_dd_derivatives?(nodes)
          nodes.find.with_index do |node, index|
            next unless %w[msub msup msubsup].include?(node.name)

            next_node = nodes[index + 1]
            next unless next_node
            next if next_node.name == "mo"

            DERIVATIVE_CONSTS.include?(node.nodes.first.nodes.first)
          end
        end

        def validate_upcase_dd_derivatives?(nodes)
          return false unless nodes[0]&.nodes&.first == "&#x2145;"
          return false unless nodes[1].name == "mi"

          true
        end

        def upcase_dd_derivative(nodes)
          mrow_nodes = []
          while true
            node = nodes[1]
            case node.name
            when "mi"
              mrow_nodes << nodes.delete_at(1)
              next
            when "mrow"
              second_arg = mrow_nodes.map { |n| encode(n.nodes.first) }.join
              third_arg  = upcase_dd_intent_name(node.nodes[1..-2])
              mrow_nodes << nodes.delete_at(1)
              break
            end
            break
          end
          intent_name = "#{intent_names[:derivative]}(1,#{second_arg},#{third_arg})"
          mrow = ox_element("mrow", attributes: { intent: intent_name })
          nodes.insert(0, XmlHelper.update_nodes(mrow, mrow_nodes))
        end

        def subsup_dd_derivative(nodes)
          iteration = 0
          return unless DERIVATIVE_CONSTS.include?(nodes[iteration].nodes[iteration].nodes.first)

          while iteration < nodes.length
            node = nodes[iteration]
            next iteration += 1 unless node.nodes[0].is_a?(Plurimath::XmlEngine::OxEngine::Element)

            if DERIVATIVE_CONSTS.include?(node.nodes[0]&.nodes&.first)
              iteration += 1
              node["intent"] =
                "#{intent_names[:derivative]}#{derivative_intent_name(node.nodes[1],
                                                                      nodes[iteration..], type: node.name)}"
              next_node = nodes[iteration]
              case next_node.name
              when "mi", "mrow"
                if ["mi", "mrow"].include?(nodes[iteration + 1].name)
                  wrap_in_mrow(nodes[iteration..])
                else
                  next_node["arg"] = "f"
                end
              end
            end
            iteration += 1
          end
        end

        def derivative_intent_name(node, next_nodes, type:)
          case type
          when "msub"
            first_value, second_value = sub_intent_content(node)
            "(#{first_value},$f,#{second_value})"
          when "msup"
            "(#{sup_intent_content(node)},$f,#{sup_second_content(next_nodes)})"
          end
        end

        def sub_intent_content(node)
          return ["1", encode(node.nodes[0])] if node.name == "mi"
          return numeric_encoding(node) if node.name == "mn"
          return ["1"] if node["intent"] == "fenced"
          return unless node.name == "mrow"

          ["1"] unless node.nodes.all? { |element| element.name == "mi" }
        end

        def sup_intent_content(node)
          return encode(first_node) if node.name == "mi"
          return node.nodes[0] if node.name == "mn"

          "$n" if node.name == "mrow"
        end

        def sup_second_content(next_nodes)
          fence_node = nil
          next_nodes.each do |node|
            break if fence_node

            next if %w[mi mn].include?(node.name)

            fence_node = node if node.name == "mrow" && node["intent"] == ":fenced"
            break unless %w[mi mn].include?(node.name)
          end
          return if fence_node.nil?

          nodes = fence_node.nodes[1..]
          sliced_nodes = nodes.slice_before { |node| node.name == "mn" }
          str = ""
          sliced_nodes.to_a.last.each do |node|
            break unless %w[msub msup msubsup mi mn].include?(node.name)

            case node.name
            when "msub", "msup", "msubsup"
              powerbase_nodes = node.nodes
              str += encode(powerbase_nodes.first.nodes.first)
              str += encode(powerbase_nodes.last.nodes.first) if valid_prime?(powerbase_nodes.last)
            when "mi", "mn"
              str += node.nodes.first
            end
          end
          str
        end

        def wrap_in_mrow(nodes)
          mrow = ox_element("mrow", attributes: { arg: "f" })
          row_nodes = []
          loop do
            node = nodes.shift if ["mi", "mrow"].include?(nodes[0].name)
            row_nodes << node
            next if node.name == "mi"
            break if node.name == "mrow"
          end
          XmlHelper.update_nodes(mrow, row_nodes)
        end

        def numeric_encoding(node)
          nodes = node.nodes[0].chars
          [nodes.length, nodes.join(",")]
        end

        def valid_prime?(node)
          Utility.primes_constants.values.any?(node.nodes.first)
        end

        def encode(str)
          Utility.html_entity_to_unicode(str)
        end

        def upcase_dd_intent_name(nodes)
          str = ""
          nodes.each do |node|
            case node.name
            when "mi"
              str += node.nodes.first
            when "mn"
              str = node.nodes.first
            when "msub", "msup", "msubsup"
              next unless %w[mi mn].include?(node.nodes[0].name)

              str = node.nodes[0] if node.nodes.first.name == "mn"
              str += node.nodes[0].nodes[0] if node.nodes.first.name == "mi"
              sup_index = node.name == "msubsup" ? 2 : 1
              str += node.nodes[sup_index].nodes[0] if valid_prime?(node.nodes[sup_index])
            else
              str = "" if node.name == "mfrac"
              break
            end
          end
          encode(str)
        end
        # Dd derivative nodes end

      end
    end
  end
end
