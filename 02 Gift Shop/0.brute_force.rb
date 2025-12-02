# Here is a brute force solution for a performance comparison.
# This is linear, whereas `0.rb` is `Θ(∑(n=2..∞) { n√N }) ≅ Θ(√N)`.
PART2 = true
regexp = /\A(\d+?)\1#{'+' if PART2}\z/
puts(ARGF.each(',').sum do|range|
  first, last = range.split('-').map(&:to_i) #: [Integer, Integer]
  (first..last).sum { _1.to_s.match?(regexp) ? _1 : 0 }
end)
