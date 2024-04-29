module Plurimath
  module Math
    module Symbols
      class Measangledrtose < Symbol
        INPUT = {
          unicodemath: [["&#x29ae;"], parsing_wrapper(["measangledrtose"])],
          asciimath: [["&#x29ae;"], parsing_wrapper(["measangledrtose"])],
          mathml: ["&#x29ae;"],
          latex: [["measangledrtose", "&#x29ae;"]],
          omml: ["&#x29ae;"],
          html: ["&#x29ae;"],
        }.freeze

        # output methods
        def to_latex
          "\\measangledrtose"
        end

        def to_asciimath
          parsing_wrapper("measangledrtose")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29ae;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29ae;"
        end

        def to_omml_without_math_tag(_)
          "&#x29ae;"
        end

        def to_html
          "&#x29ae;"
        end
      end
    end
  end
end
