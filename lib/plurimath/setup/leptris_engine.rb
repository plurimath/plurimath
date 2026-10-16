# frozen_string_literal: true

begin
  require "leptris"
rescue LoadError
  raise LoadError,
        "the leptris XML engine needs the leptris gem " \
        "(gem install leptris, or add `gem \"leptris\"` to your Gemfile). " \
        "leptris is an opt-in soft dependency, like the oga engine."
end

require "plurimath/xml_engine/leptris_engine"

Plurimath.xml_engine = Plurimath::XmlEngine::LeptrisEngine
