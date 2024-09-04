module Plurimath
  module Math
    module Symbols
      class Curlyeqprec < Symbol
        INPUT = {
          unicodemath: [["curlyeqprec", "&#x22de;"]],
          asciimath: [["&#x22de;"], parsing_wrapper(["curlyeqprec"], lang: :asciimath)],
          mathml: ["&#x22de;"],
          latex: [["curlyeqprec", "&#x22de;"]],
          omml: ["&#x22de;"],
          html: ["&#x22de;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\curlyeqprec"
        end

        def to_asciimath(**)
          parsing_wrapper("curlyeqprec", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22de;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22de;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22de;"
        end

        def to_html(**)
          "&#x22de;"
        end
      end
    end
  end
end
