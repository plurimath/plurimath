module Plurimath
  module Math
    module Symbols
      class Uparrowbarred < Symbol
        INPUT = {
          unicodemath: [["&#x2909;"], parsing_wrapper(["uparrowbarred"], lang: :unicode)],
          asciimath: [["&#x2909;"], parsing_wrapper(["uparrowbarred"], lang: :asciimath)],
          mathml: ["&#x2909;"],
          latex: [["uparrowbarred", "&#x2909;"]],
          omml: ["&#x2909;"],
          html: ["&#x2909;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\uparrowbarred"
        end

        def to_asciimath(**)
          parsing_wrapper("uparrowbarred", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2909;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2909;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2909;"
        end

        def to_html(**)
          "&#x2909;"
        end
      end
    end
  end
end
