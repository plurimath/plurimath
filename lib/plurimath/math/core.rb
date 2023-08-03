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

      def omml_tag_name
        "subSup"
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

      def r_element(string, rpr_tag: true)
        r_tag = Utility.ox_element("r", namespace: "m")
        if rpr_tag
          sty_tag = Utility.ox_element("sty", namespace: "m", attributes: { "m:val": "p" })
          r_tag << (Utility.ox_element("rPr", namespace: "m") << sty_tag)
        end
        r_tag << (Utility.ox_element("t", namespace: "m") << string)
        Array(r_tag)
      end
    end
  end
end
