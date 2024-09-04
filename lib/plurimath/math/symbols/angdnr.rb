module Plurimath
  module Math
    module Symbols
      class Angdnr < Symbol
        INPUT = {
          unicodemath: [["&#x299f;"], parsing_wrapper(["angdnr"], lang: :unicode)],
          asciimath: [["&#x299f;"], parsing_wrapper(["angdnr"], lang: :asciimath)],
          mathml: ["&#x299f;"],
          latex: [["angdnr", "&#x299f;"]],
          omml: ["&#x299f;"],
          html: ["&#x299f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\angdnr"
        end

        def to_asciimath(**)
          parsing_wrapper("angdnr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x299f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x299f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x299f;"
        end

        def to_html(**)
          "&#x299f;"
        end
      end
    end
  end
end
