module Plurimath
  module Math
    module Symbols
      class Imath < Symbol
        INPUT = {
          unicodemath: [["imath", "&#x131;"]],
          asciimath: [["&#x131;"], parsing_wrapper(["imath"], lang: :asciimath)],
          mathml: ["&#x131;"],
          latex: [["imath", "&#x131;"]],
          omml: ["&#x131;"],
          html: ["&#x131;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\imath"
        end

        def to_asciimath(**)
          parsing_wrapper("imath", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x131;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x131;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x131;"
        end

        def to_html(**)
          "&#x131;"
        end
      end
    end
  end
end
