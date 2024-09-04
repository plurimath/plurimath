module Plurimath
  module Math
    module Symbols
      class Bigslopedwedge < Symbol
        INPUT = {
          unicodemath: [["&#x2a58;"], parsing_wrapper(["bigslopedwedge"], lang: :unicode)],
          asciimath: [["&#x2a58;"], parsing_wrapper(["bigslopedwedge"], lang: :asciimath)],
          mathml: ["&#x2a58;"],
          latex: [["bigslopedwedge", "&#x2a58;"]],
          omml: ["&#x2a58;"],
          html: ["&#x2a58;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigslopedwedge"
        end

        def to_asciimath(**)
          parsing_wrapper("bigslopedwedge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a58;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a58;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a58;"
        end

        def to_html(**)
          "&#x2a58;"
        end
      end
    end
  end
end
