module Plurimath
  module Math
    module Symbols
      class Geqq < Symbol
        INPUT = {
          unicodemath: [["geqq", "&#x2267;"]],
          asciimath: [["&#x2267;"], parsing_wrapper(["geqq"], lang: :asciimath)],
          mathml: ["&#x2267;"],
          latex: [["geqq", "&#x2267;"]],
          omml: ["&#x2267;"],
          html: ["&#x2267;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\geqq"
        end

        def to_asciimath(**)
          parsing_wrapper("geqq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2267;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2267;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2267;"
        end

        def to_html(**)
          "&#x2267;"
        end
      end
    end
  end
end
