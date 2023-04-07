# frozen_string_literal: true

require_relative 'tree'

# Create a binary search tree from an array of random numbers 
array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)
tree.pretty_print

# Confirm that the tree is balanced by calling #balanced?
puts "Balanced: #{tree.balanced?}"

# Print out all elements in level, pre, post, and in order
puts "Printing in level order: #{tree.level_order}"
puts "Printing in pre-order: #{tree.pre_order}"
puts "Printing in post-order: #{tree.post_order}"
puts "Printing in in-order: #{tree.in_order}"

# Unbalance the tree by adding several numbers > 100
200.times do
  tree.insert(rand(1..1000))
end
tree.pretty_print

# Confirm that the tree is unbalanced by calling #balanced?
puts "Balanced: #{tree.balanced?}"

# Balance the tree by calling #rebalance
tree.rebalance
tree.pretty_print

# Confirm that the tree is balanced by calling #balanced?
puts "Balanced: #{tree.balanced?}"

# Print out all elements in level, pre, post, and in order
puts "Printing in level order: #{tree.level_order}"
puts "Printing in pre-order: #{tree.pre_order}"
puts "Printing in post-order: #{tree.post_order}"
puts "Printing in in-order: #{tree.in_order}"
