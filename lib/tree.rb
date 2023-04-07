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

  # Depth is the number of edges in path from a given node to the tree’s root node.
  def depth(node)
    height(@root) - height(node)
  end

  def find(value)
    pointer = @root
    pointer = pointer.navigate(value) until pointer.nil? || pointer.data == value
    pointer
  end

  # Height is the number of edges in longest path from a given node to a leaf node.
  def height(node, height = 0)
    left_height = node.left ? height(node.left, height + 1) : height
    right_heigt = node.right ? height(node.right, height + 1) : height
    left_height > right_heigt ? left_height : right_heigt
  end

  def in_order(node = @root, visited = [], &block)
    visited = in_order(node.left, visited, &block) if node.left
    block.call(node.data) if block_given?
    visited.push(node.data)
    visited = in_order(node.right, visited, &block) if node.right
    visited
  end

  def level_order(&block)
    queue = @root.nil? ? [] : [@root]
    visited = []

    until queue.empty?
      current = queue.shift
      queue.push(current.left) if current.left
      queue.push(current.right) if current.right
      visited.push current.data
      block.call(current.data) if block_given?
    end
    visited
  end

  def pre_order(node = @root, visited = [], &block)
    block.call(node.data) if block_given?
    visited.push(node.data)
    visited = pre_order(node.left, visited, &block) if node.left
    visited = pre_order(node.right, visited, &block) if node.right
    visited
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def post_order(node = @root, visited = [], &block)
    visited = post_order(node.left, visited, &block) if node.left
    visited = post_order(node.right, visited, &block) if node.right
    block.call(node.data) if block_given?
    visited.push(node.data)
    visited
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
