# frozen_string_literal: true

module Plurimath
  class Html
    # Html-specific helper extracted from Plurimath::Utility (code-quality
    # refactor). Subclasses Utility so bareword `Utility.<generic>` calls inside
    # Html files keep resolving here and inherit the generic helpers.
    class Utility < Plurimath::Utility
      class << self
        def sub_sup_method?(sub_sup)
          if sub_sup.methods.include?(:class_name)
            Html::Constants::SUB_SUP_CLASSES.value?(sub_sup.class_name.to_sym)
          end
        end
      end
    end
  end
end
