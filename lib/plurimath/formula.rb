# frozen_string_literal: true

module Plurimath
  # Formula Class
  class Formula
    attr_accessor :text, :children

    def initialize(str, children = [])
      @text = str.text
      @children = children
    end

    def to_s
      new_ar = []
      @children.each do |child|
        new_child = child[:text] || child[:value]
        new_ar << new_child
      end
      new_ar.join('')
    end

    def append_child(token)
      @children << token
    end

    def child_nodes
      @children
    end
  end
end
