module Plurimath
  module Math
    module Symbols
      class Eqqsim < Symbol
        INPUT = {
          unicodemath: [["&#x2a73;"], parsing_wrapper(["eqqsim"], lang: :unicode)],
          asciimath: [["&#x2a73;"], parsing_wrapper(["eqqsim"], lang: :asciimath)],
          mathml: ["&#x2a73;"],
          latex: [["eqqsim", "&#x2a73;"]],
          omml: ["&#x2a73;"],
          html: ["&#x2a73;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqqsim"
        end

        def to_asciimath(**)
          parsing_wrapper("eqqsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a73;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a73;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a73;"
        end

        def to_html(**)
          "&#x2a73;"
        end
      end
    end
  end
end
