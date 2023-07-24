# frozen_string_literal: true

module Plurimath
  module Math
    class Core
      def class_name
        self.class.name.split("::").last.downcase
      end

      def insert_t_tag
        Array(to_omml_without_math_tag)
      end

      def tag_name
        "subsup"
      end

      def nary_attr_value
        ""
      end

      def empty_tag(wrapper_tag)
        r_tag = Utility.ox_element("r", namespace: "m")
        r_tag << (Utility.ox_element("t", namespace: "m") << "&#8203;")
        wrapper_tag << r_tag
      end

      def omml_parameter(field, tag_name: , namespace: "m")
        tag = Utility.ox_element(tag_name, namespace: namespace)
        return empty_tag(tag) unless field

        Utility.update_nodes(
          tag,
          field&.insert_t_tag,
        )
      end

      def validate_function_formula
        true
      end
    end
  end
end
