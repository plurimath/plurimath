module Plurimath
  module Math
    module Symbols
      class Uprightcurvearrow < Symbol
        INPUT = {
          unicodemath: [["&#x2934;"], parsing_wrapper(["uprightcurvearrow"])],
          asciimath: [["&#x2934;"], parsing_wrapper(["uprightcurvearrow"])],
          mathml: ["&#x2934;"],
          latex: [["uprightcurvearrow", "&#x2934;"]],
          omml: ["&#x2934;"],
          html: ["&#x2934;"],
        }.freeze

        # output methods
        def to_latex
          "\\uprightcurvearrow"
        end

        def to_asciimath
          parsing_wrapper("uprightcurvearrow")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2934;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2934;"
        end

        def to_omml_without_math_tag(_)
          "&#x2934;"
        end

        def to_html
          "&#x2934;"
        end
      end
    end
  end
end
