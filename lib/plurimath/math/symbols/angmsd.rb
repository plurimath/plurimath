module Plurimath
  module Math
    module Symbols
      class Angmsd < Symbol
        INPUT = {
          unicodemath: [["angmsd", "&#x2221;"], parsing_wrapper(["measuredangle"])],
          asciimath: [["&#x2221;"], parsing_wrapper(["angmsd", "measuredangle"])],
          mathml: ["&#x2221;"],
          latex: [["measuredangle", "&#x2221;"], parsing_wrapper(["angmsd"])],
          omml: ["&#x2221;"],
          html: ["&#x2221;"],
        }.freeze

        # output methods
        def to_latex
          "\\measuredangle"
        end

        def to_asciimath
          parsing_wrapper("angmsd")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2221;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2221;"
        end

        def to_omml_without_math_tag(_)
          "&#x2221;"
        end

        def to_html
          "&#x2221;"
        end
      end
    end
  end
end
