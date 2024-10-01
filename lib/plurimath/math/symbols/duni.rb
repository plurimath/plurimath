module Plurimath
  module Math
    module Symbols
      class Duni < Symbol
        INPUT = {
          unicodemath: [["&#x22c3;"], parsing_wrapper(["bigcup", "uuu", "duni"], lang: :unicode)],
          asciimath: [["bigcup", "uuu", "&#x22c3;"], parsing_wrapper(["duni"], lang: :asciimath)],
          mathml: ["&#x22c3;"],
          latex: [["bigcup", "duni", "&#x22c3;"], parsing_wrapper(["uuu"], lang: :latex)],
          omml: ["&#x22c3;"],
          html: ["&#x22c3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigcup"
        end

        def to_asciimath(**)
          parsing_wrapper("duni", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22c3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22c3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22c3;"
        end

        def to_html(**)
          "&#x22c3;"
        end

        def nary_intent_name
          ":n-ary"
        end

        def is_nary_symbol?
          true
        end
      end
    end
  end
end
