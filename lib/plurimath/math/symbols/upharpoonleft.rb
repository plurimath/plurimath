module Plurimath
  module Math
    module Symbols
      class Upharpoonleft < Symbol
        INPUT = {
          unicodemath: [["upharpoonleft", "&#x21bf;"], parsing_wrapper(["upharpoonleftup"], lang: :unicode)],
          asciimath: [["&#x21bf;"], parsing_wrapper(["upharpoonleft", "upharpoonleftup"], lang: :asciimath)],
          mathml: ["&#x21bf;"],
          latex: [["upharpoonleftup", "upharpoonleft", "&#x21bf;"]],
          omml: ["&#x21bf;"],
          html: ["&#x21bf;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upharpoonleftup"
        end

        def to_asciimath(**)
          parsing_wrapper("upharpoonleft", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21bf;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21bf;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21bf;"
        end

        def to_html(**)
          "&#x21bf;"
        end
      end
    end
  end
end
