module Plurimath
  module Math
    module Symbols
      class Fisheye < Symbol
        INPUT = {
          unicodemath: [["&#x25c9;"], parsing_wrapper(["fisheye"], lang: :unicode)],
          asciimath: [["&#x25c9;"], parsing_wrapper(["fisheye"], lang: :asciimath)],
          mathml: ["&#x25c9;"],
          latex: [["fisheye", "&#x25c9;"]],
          omml: ["&#x25c9;"],
          html: ["&#x25c9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\fisheye"
        end

        def to_asciimath(**)
          parsing_wrapper("fisheye", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25c9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25c9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25c9;"
        end

        def to_html(**)
          "&#x25c9;"
        end
      end
    end
  end
end
