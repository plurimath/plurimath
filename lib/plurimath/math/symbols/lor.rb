module Plurimath
  module Math
    module Symbols
      class Lor < Symbol
        INPUT = {
          unicodemath: [["lor", "&#x2228;"], parsing_wrapper(["vee", "vv"], lang: :unicode)],
          asciimath: [["vee", "vv", "&#x2228;"], parsing_wrapper(["lor"], lang: :asciimath)],
          mathml: ["&#x2228;"],
          latex: [["vee", "lor", "&#x2228;"], parsing_wrapper(["vv"], lang: :latex)],
          omml: ["&#x2228;"],
          html: ["&#x2228;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vee"
        end

        def to_asciimath(**)
          parsing_wrapper("lor", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2228;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2228;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2228;"
        end

        def to_html(**)
          "&#x2228;"
        end
      end
    end
  end
end
