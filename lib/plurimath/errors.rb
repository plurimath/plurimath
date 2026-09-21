# frozen_string_literal: true

module Plurimath
  module Errors
    autoload :Evaluation, "#{__dir__}/errors/evaluation"
    autoload :InvalidNumber, "#{__dir__}/errors/invalid_number"
    autoload :RenderingFailed, "#{__dir__}/errors/rendering_failed"
    autoload :RenderingUnavailable, "#{__dir__}/errors/rendering_unavailable"
    autoload :UnsupportedBase, "#{__dir__}/errors/unsupported_base"
    autoload :UnsupportedLocale, "#{__dir__}/errors/unsupported_locale"
    autoload :UnsupportedRenderFormat, "#{__dir__}/errors/unsupported_render_format"
  end
end
