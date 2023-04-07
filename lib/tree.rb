# frozen_string_literal: true

require_relative 'node'

# Tree represents a Binary Tree. It receives an array in the constructor.
class Tree
  def initialize(array)
    @root = build_tree(array)
  end

  def delete(value)
    node = find(value)
    parent = find_parent(value)

    case node.children
    when 0 then delete_leaf(node, parent)
    when 1 then delete_node_has_child(node, parent)
    when 2 then delete_node_has_children(node, parent)
    end
  end

  def find(value)
    pointer = @root
    pointer = pointer.navigate(value) until pointer.nil? || pointer.data == value
    pointer
  end

  def insert(value)
    new_node = Node.new(value)
    @root = new_node if @root.nil?

    pointer = @root
    loop do
      return nil if value == pointer.data

      if pointer.navigate(value).nil?
        return value < pointer.data ? pointer.left = new_node : pointer.right = new_node
      end

      pointer = pointer.navigate(value)
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def build_node(array)
    return nil if array.empty?

    middle = array.length / 2
    node = Node.new(array[middle])
    node.left = build_node(array.take(middle))
    node.right = build_node(array.drop(middle + 1))
    node
  end

  def build_tree(array)
    build_node(array.sort.uniq)
  end

  def delete_leaf(node, parent)
    case node <=> parent
    when 0 then @root = nil
    when -1 then parent.left = nil
    when 1 then parent.right = nil
    end
  end

  def delete_node_has_child(node, parent)
    if node.right.nil?
      node == parent ? @root = node.left : point_to(parent, node.left)
    else
      node == parent ? @root = node.right : point_to(parent, node.right)
    end
  end

  def delete_node_has_children(node, parent)
    next_biggest = lowest_child(node.right)
    delete(next_biggest.data)
    node == parent ? @root = next_biggest : point_to(parent, next_biggest)
    point_to(next_biggest, node.right)
    point_to(next_biggest, node.left)
  end

  # Given a node value, it will return the parent node
  # If the value is in the root, returns @root
  # If the value is not found in the table, it returns nil
  def find_parent(value)
    pointer = @root
    return pointer if pointer.nil? || pointer.data == value

    loop do
      next_node = pointer.navigate(value)
      return if next_node.nil?
      break if next_node.data == value

      pointer = next_node
    end
    pointer
  end

  def lowest_child(node)
    node = node.left until node.left.nil?
    node
  end

  def point_to(parent, child)
    return if child.nil?

    if child < parent
      parent.left = child
    else
      parent.right = child
    end
  end
end
