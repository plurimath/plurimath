module Plurimath
  module Math
    module Symbols
      class Simeq < Symbol
        INPUT = {
          unicodemath: [["simeq", "&#x2243;"]],
          asciimath: [["&#x2243;"], parsing_wrapper(["simeq"], lang: :asciimath)],
          mathml: ["&#x2243;"],
          latex: [["simeq", "&#x2243;"]],
          omml: ["&#x2243;"],
          html: ["&#x2243;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\simeq"
        end

        def to_asciimath(**)
          parsing_wrapper("simeq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2243;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2243;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2243;"
        end

        def to_html(**)
          "&#x2243;"
        end
      end
    end
  end
end
