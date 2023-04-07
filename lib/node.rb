# frozen_string_literal: true

# Node represents the node of a binary tree.
class Node
  include Comparable

  attr_accessor :left, :right
  attr_reader :data

  def initialize(value)
    @data = value
  end

  def <=>(other)
    data <=> other.data
  end

  def children
    children = 0
    children += 1 if @left
    children += 1 if @right
    children
  end

  def navigate(value)
    return self if value == @data

    value < @data ? @left : @right
  end
end
