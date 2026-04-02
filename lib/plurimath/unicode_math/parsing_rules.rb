# frozen_string_literal: true

module Plurimath
  class UnicodeMath
    module ParsingRules
      autoload :AbsenceRules, "#{__dir__}/parsing_rules/absence_rules"
      autoload :CommonRules, "#{__dir__}/parsing_rules/common_rules"
      autoload :ConstantsRules, "#{__dir__}/parsing_rules/constants_rules"
      autoload :Helper, "#{__dir__}/parsing_rules/helper"
      autoload :Masked, "#{__dir__}/parsing_rules/masked"
      autoload :SubSup, "#{__dir__}/parsing_rules/sub_sup"
    end
  end
end
