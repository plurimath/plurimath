module Plurimath
  module Math
    module Symbols
      class Supsetneq < Symbol
        INPUT = {
          unicodemath: [["supsetneq", "&#x228b;"]],
          asciimath: [["&#x228b;"], parsing_wrapper(["supsetneq"], lang: :asciimath)],
          mathml: ["&#x228b;"],
          latex: [["supsetneq", "&#x228b;"]],
          omml: ["&#x228b;"],
          html: ["&#x228b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\supsetneq"
        end

        def to_asciimath(**)
          parsing_wrapper("supsetneq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x228b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x228b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x228b;"
        end

        def to_html(**)
          "&#x228b;"
        end
      end
    end
  end
end
