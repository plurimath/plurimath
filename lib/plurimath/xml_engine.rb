module Plurimath
  singleton_class.attr_accessor :xml_engine

  module XmlEngine
    autoload :Oga, "plurimath/xml_engine/oga"
    autoload :Ox, "plurimath/xml_engine/ox"
  end
end
