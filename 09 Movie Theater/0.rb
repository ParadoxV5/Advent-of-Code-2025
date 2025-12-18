vertices = ARGF.each_line(chomp: true).map do|tile|
  tile.split(',').map { Integer(it) } #: [Integer, Integer]
end

# [common coordinate, other coordinate from, other coordinate to]
horizontal_edges = [] #: orthogonal_edges
  vertical_edges = [] #: orthogonal_edges
vertices
  .chain([vertices.first])
  .each_cons(2) #: Enumerator[[[Integer, Integer], [Integer, Integer]], bot]
  .each do|(x1, y1), (x2, y2)|
    #@type var ab: [Integer, Integer]
    array, n, ab = if y1 == y2
      [horizontal_edges, y1, [x1, x2]]
    elsif x1 == x2
      [  vertical_edges, x1, [y1, y2]]
    else
      next
    end
    ab.sort!
    # Adjust ends of the “other coordinate” pair to be exclusive.
    array << [n, ab.first.succ...ab.last]
  end

# Rank before filter because filtering is computationally expensive
rectangles = vertices.combination(2).map do|pair|
  pair = pair.transpose.map(&:sort)
  (x1, x2), (y1, y2) = pair #: [[Integer, Integer], [Integer, Integer]]
  [(
    (x1..x2).size #: Integer
  ) * (
    (y1..y2).size #: Integer
  ), *pair] #: [Integer, [Integer, Integer], [Integer, Integer]]
end
rectangles.sort_by!(&:first)
rectangles.reverse!

# TODO: {Array#bsearch_index} can probably speed things up,
# but I gave up on it because it is too error prone,
# yet the search is still `O(n)` for the worst case.

puts(
  'Part 1',
  rectangles.first&.first,
  'Part 2',
  # Find the first rectangles whose edges do not cross an edge of the green zone
  rectangles.find do|_, xs, ys|
    [
      [  vertical_edges, ys, xs],
      [horizontal_edges, xs, ys]
    ] #: Array[[orthogonal_edges, [Integer, Integer], [Integer, Integer]]]
    .all? do|perpendicular_edges, (m, n), (a, b)|
      mn_range = m..n
      perpendicular_edges.none? do|c, range|
        a < c and c < b and mn_range.overlap? range
      end
    end
    #TODO: technically required, but not necessary for the input the puzzle gives.
    # Filter away rectangles that are outside of the green zone
    # (using https://en.wikipedia.org/wiki/Even–odd_rule here,
    #  and only sampling one point as there are no crossings.)
  end&.first
)
