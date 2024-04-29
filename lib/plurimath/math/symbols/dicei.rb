module Plurimath
  module Math
    module Symbols
      class Dicei < Symbol
        INPUT = {
          unicodemath: [["&#x2680;"], parsing_wrapper(["dicei"])],
          asciimath: [["&#x2680;"], parsing_wrapper(["dicei"])],
          mathml: ["&#x2680;"],
          latex: [["dicei", "&#x2680;"]],
          omml: ["&#x2680;"],
          html: ["&#x2680;"],
        }.freeze

        # output methods
        def to_latex
          "\\dicei"
        end

        def to_asciimath
          parsing_wrapper("dicei")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2680;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2680;"
        end

        def to_omml_without_math_tag(_)
          "&#x2680;"
        end

        def to_html
          "&#x2680;"
        end
      end
    end
  end
end
