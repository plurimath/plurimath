module Plurimath
  module Math
    module Symbols
      class Curlyeqsucc < Symbol
        INPUT = {
          unicodemath: [["curlyeqsucc", "&#x22df;"]],
          asciimath: [["&#x22df;"], parsing_wrapper(["curlyeqsucc"], lang: :asciimath)],
          mathml: ["&#x22df;"],
          latex: [["curlyeqsucc", "&#x22df;"]],
          omml: ["&#x22df;"],
          html: ["&#x22df;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\curlyeqsucc"
        end

        def to_asciimath(**)
          parsing_wrapper("curlyeqsucc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22df;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22df;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22df;"
        end

        def to_html(**)
          "&#x22df;"
        end
      end
    end
  end
end
