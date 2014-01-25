# methods_returning.rb
#
# Author: Peter Cooper (http://peterc.org/)
#
# A method to work out which method on an object returns what we want
#
require 'stringio'
require 'timeout'
 
class Object
  def methods_returning(expected, *args, &blk)
    old_stdout = $>
    $> = StringIO.new
 
    methods.select do |meth|
      Timeout::timeout(1) { dup.public_send(meth, *args, &blk) == expected rescue false } rescue false
    end
  ensure
    $> = old_stdout
  end
end

# Usage:

# p [1, nil, 'x'].methods_returning [1, 'x']
# # => [:compact, :compact!]
#  
# p [1, 2, 3].methods_returning [3, 2, 1]
# # => [:reverse, :reverse!]
#  
# p [1, 2, 3].methods_returning []
# # => [:values_at, :clear, :singleton_methods, :protected_methods, :instance_variables]
#  
# p [1, 2, 3].methods_returning([2, 4, 6]) { |i| i * 2 }
# # => [:collect, :collect!, :map, :map!, :flat_map, :collect_concat]
#  
# p [1, 2, 3].methods_returning('123')
# # => [:join]
#  
# p (1..5).methods_returning([[1, 3, 5], [2, 4]], &:odd?)
# # => [:partition]
#  
# p 'A'.methods_returning 'a'
# # => [:downcase, :swapcase, :downcase!, :swapcase!]