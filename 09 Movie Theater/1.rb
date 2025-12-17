# “Given a list of cartesian coordicates,
# find the area of the largest rectangular area that two entries can make.”
# Yeah this is too trivial for both junior programmers and AIs alike.
puts(
  ARGF.each_line(chomp: true).map do|tile|
    tile.split(',').map { Integer(it) }
  end.combination(2).lazy.map do|pair|
    pair.transpose.map do|dimension|
      Range.new(*dimension.minmax).size
    end.inject(:*)
  end.max
)
