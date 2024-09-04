module Plurimath
  module Math
    module Symbols
      class Ocirc < Symbol
        INPUT = {
          unicodemath: [["ocirc", "&#x229a;"], parsing_wrapper(["circledcirc"], lang: :unicode)],
          asciimath: [["&#x229a;"], parsing_wrapper(["ocirc", "circledcirc"], lang: :asciimath)],
          mathml: ["&#x229a;"],
          latex: [["circledcirc", "&#x229a;"], parsing_wrapper(["ocirc"], lang: :latex)],
          omml: ["&#x229a;"],
          html: ["&#x229a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circledcirc"
        end

        def to_asciimath(**)
          parsing_wrapper("ocirc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x229a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x229a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x229a;"
        end

        def to_html(**)
          "&#x229a;"
        end
      end
    end
  end
end
