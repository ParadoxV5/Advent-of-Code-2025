# These elves are really looking for a
# https://en.wikipedia.org/wiki/Minimum_spanning_tree.
# But hey, instructions are instructions.

nodes = ARGF.each_line(chomp: true).map do|line|
  line.split(',').map { Integer(it) }
end
# Part 1 can cut off at the given limit with {Enumerable#min_by}.
edges = nodes.combination(2).sort_by do|pair|
  pair.transpose.sum { it.inject(:-) ** 2 }
end

networks = Hash.new {|hash, key| hash[key] = [key] } #$ Array[Integer], Array[Array[Integer]]
networks.compare_by_identity
edges.each.with_index(1) do|pair, count|
  network_a, network_b = networks.values_at(*pair) #: [Array[Array[Integer]], Array[Array[Integer]]]
  unless network_a.equal? network_b
    network_a.push *network_b
    network_b.each { networks[it] = network_a }
    # For Part 2, all boxes are connected in the same network
    # when the network of *any* node includes every node.
    if network_a.size >= nodes.size
      puts 'Part 2', pair.map(&:first).inject(:*)
      break
    end
  end
  if count == 1000 # Example: 10
    puts 'Part 1',
      networks.each_value.uniq(&:__id__).map(&:size).max(3).inject(:*)
  end
end
