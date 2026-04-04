# frozen_string_literal: true

require "mml"

module Plurimath
  class Mathml
    class Parser
      CONFIGURATION = {
        Mml::V4::MathWithNamespace => Plurimath::Math::Formula,
        Mml::V4::Mmultiscripts => Plurimath::Math::Function::Multiscript,
        Mml::V4::Mlabeledtr => Plurimath::Math::Function::Mlabeledtr,
        Mml::V4::Munderover => Plurimath::Math::Function::Underover,
        Mml::V4::Semantics => Plurimath::Math::Function::Semantics,
        Mml::V4::Mscarries => Plurimath::Math::Function::Scarries,
        Mml::V4::Mfraction => Plurimath::Math::Function::Frac,
        Mml::V4::Menclose => Plurimath::Math::Function::Menclose,
        Mml::V4::Mlongdiv => Plurimath::Math::Function::Longdiv,
        Mml::V4::Mphantom => Plurimath::Math::Function::Phantom,
        Mml::V4::Msubsup => Plurimath::Math::Function::PowerBase,
        Mml::V4::Msgroup => Plurimath::Math::Function::Msgroup,
        Mml::V4::Mpadded => Plurimath::Math::Function::Mpadded,
        Mml::V4::Mfenced => Plurimath::Math::Function::Fenced,
        Mml::V4::Mstack => Plurimath::Math::Function::Stackrel,
        Mml::V4::Munder => Plurimath::Math::Function::Underset,
        Mml::V4::Msline => Plurimath::Math::Function::Msline,
        Mml::V4::Merror => Plurimath::Math::Function::Merror,
        Mml::V4::Mtable => Plurimath::Math::Function::Table,
        Mml::V4::Mstyle => Plurimath::Math::Formula::Mstyle,
        Mml::V4::Mglyph => Plurimath::Math::Function::Mglyph,
        Mml::V4::Mover => Plurimath::Math::Function::Overset,
        Mml::V4::Msqrt => Plurimath::Math::Function::Sqrt,
        Mml::V4::Mroot => Plurimath::Math::Function::Root,
        Mml::V4::Mtext => Plurimath::Math::Function::Text,
        Mml::V4::Mfrac => Plurimath::Math::Function::Frac,
        Mml::V4::Msrow => Plurimath::Math::Formula,
        Mml::V4::Msup => Plurimath::Math::Function::Power,
        Mml::V4::Msub => Plurimath::Math::Function::Base,
        Mml::V4::None => Plurimath::Math::Function::None,
        Mml::V4::Mrow => Plurimath::Math::Formula::Mrow,
        Mml::V4::Mtd => Plurimath::Math::Function::Td,
        Mml::V4::Mtr => Plurimath::Math::Function::Tr,
        Mml::V4::Mi => Plurimath::Math::Symbols::Symbol,
        Mml::V4::Mo => Plurimath::Math::Symbols::Symbol,
        Mml::V4::Ms => Plurimath::Math::Function::Ms,
        Mml::V4::Mn => Plurimath::Math::Number,
      }
      attr_accessor :text
      @@models_set = false

      def initialize(text)
        mml_config unless @@models_set
        @text = text
      end

      def parse
        namespace_exist = text.split(">").first.include?(" xmlns=")
        Mml.parse(text, namespace_exist: namespace_exist, version: 4)
      end

      def mml_config
        Mml::V4::Configuration.custom_models = CONFIGURATION
        # V4 classes inherit from V3, so child elements deserialize as V3 instances.
        # Apply the same custom models to V3 child classes (skip Math which has V4-only attrs).
        v3_config = CONFIGURATION.each_with_object({}) do |(v4_klass, model), hash|
          name = v4_klass.name.split("::").last
          next if %w[Math MathWithNamespace].include?(name)
          v3_klass = Mml::V3.const_get(name) if Mml::V3.const_defined?(name)
          hash[v3_klass] = model if v3_klass && v3_klass != v4_klass
        end
        Mml::V3::Configuration.custom_models = v3_config
        @@models_set = true
      end
    end
  end
end
