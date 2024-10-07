# frozen_string_literal: true

require "lutaml/model"
require_relative "mi"
require_relative "mo"
require_relative "text"
require_relative "mrow"

module Plurimath
  class Mathml
    module Parse
      class Mstyle < Lutaml::Model::Serializable
        attribute :mi, Mi
        attribute :mo, Mo
        attribute :mrow, Mrow, collection: true, default: -> { [] }

        xml do
          root "mstyle", mixed: true
          namespace nil

          map_element :mi, to: :mi
          map_element :mo, to: :mo
          map_element :mrow, to: :mrow
          map_element :mstyle, to: :mrow
        end
      end
    end
  end
end
