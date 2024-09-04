module Plurimath
  module Math
    module Symbols
      class Hookleftarrow < Symbol
        INPUT = {
          unicodemath: [["hookleftarrow", "&#x21a9;"]],
          asciimath: [["&#x21a9;"], parsing_wrapper(["hookleftarrow"], lang: :asciimath)],
          mathml: ["&#x21a9;"],
          latex: [["hookleftarrow", "&#x21a9;"]],
          omml: ["&#x21a9;"],
          html: ["&#x21a9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hookleftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("hookleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21a9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21a9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21a9;"
        end

        def to_html(**)
          "&#x21a9;"
        end
      end
    end
  end
end
