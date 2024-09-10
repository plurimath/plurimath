module Plurimath
  module Math
    module Symbols
      class Twonotes < Symbol
        INPUT = {
          unicodemath: [["&#x266b;"], parsing_wrapper(["twonotes"], lang: :unicode)],
          asciimath: [["&#x266b;"], parsing_wrapper(["twonotes"], lang: :asciimath)],
          mathml: ["&#x266b;"],
          latex: [["twonotes", "&#x266b;"]],
          omml: ["&#x266b;"],
          html: ["&#x266b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\twonotes"
        end

        def to_asciimath(**)
          parsing_wrapper("twonotes", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x266b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x266b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x266b;"
        end

        def to_html(**)
          "&#x266b;"
        end
      end
    end
  end
end
