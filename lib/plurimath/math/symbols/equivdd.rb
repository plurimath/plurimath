module Plurimath
  module Math
    module Symbols
      class Equivdd < Symbol
        INPUT = {
          unicodemath: [["&#x2a78;"], parsing_wrapper(["equivDD"], lang: :unicode)],
          asciimath: [["&#x2a78;"], parsing_wrapper(["equivDD"], lang: :asciimath)],
          mathml: ["&#x2a78;"],
          latex: [["equivDD", "&#x2a78;"]],
          omml: ["&#x2a78;"],
          html: ["&#x2a78;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\equivDD"
        end

        def to_asciimath(**)
          parsing_wrapper("equivDD", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a78;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a78;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a78;"
        end

        def to_html(**)
          "&#x2a78;"
        end
      end
    end
  end
end
