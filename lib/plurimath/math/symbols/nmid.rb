module Plurimath
  module Math
    module Symbols
      class Nmid < Symbol
        INPUT = {
          unicodemath: [["nmid", "&#x2224;"]],
          asciimath: [["&#x2224;"], parsing_wrapper(["nmid"], lang: :asciimath)],
          mathml: ["&#x2224;"],
          latex: [["nmid", "&#x2224;"]],
          omml: ["&#x2224;"],
          html: ["&#x2224;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nmid"
        end

        def to_asciimath(**)
          parsing_wrapper("nmid", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2224;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2224;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2224;"
        end

        def to_html(**)
          "&#x2224;"
        end
      end
    end
  end
end
