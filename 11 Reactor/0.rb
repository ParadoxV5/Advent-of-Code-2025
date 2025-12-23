# This is Day 7 Part 2 but the directed graph is now arbitrary.
# * Using breadth-first traversal again because
#   depth-first cannot merge repeats into multiplations
#   (My Part 1 is only ~600 but my Part 2 is 331T (out of 166P total) ❗.)
# * assuming no loops (There technically can be loops on dead ends.)

digraph = ARGF.each_line.to_h do|line|
  nodes = line.scan /\w++/ #: Array[String]
  [nodes.shift, nodes]
end

breadth_first_count = ->((from, to)) do
  queue = Hash.new(0)
  queue.compare_by_identity
  queue[from] = 1
  count = 0
  while (from, weight = queue.shift)
    if to === from
      count += weight
    elsif (neighbors = digraph[from]) #: Array[String]?
      neighbors.each { queue[_1] += weight }
    end
  end
  count
end #: ^([String, String]) -> Integer

puts(
  'Part 1',
  breadth_first_count.(%w[you out]),
  'Part 2',
  [%w[svr fft dac out], %w[svr dac fft out]].sum do|path|
    path.each_cons(2) #: Enumerator[[String, String], bot]
      .map(&breadth_first_count)
      .inject(:*)
  end
)
