# Hint and, in comments, solution:
# https://www.reddit.com/r/adventofcode/comments/1pkjynl/2025_day_12_day_12_solutions/

*shapes_input, regions_input = ARGF.readlines('', chomp: true)
shapes = shapes_input.map do|input|
  # drop ID and paragraph break
  input.each_line(chomp: true).drop(1)
end

size = shapes.lazy.flat_map(&:itself).chain(shapes).lazy.map(&:size).max
counts = shapes_input.map { it.count '#' }

puts(
  regions_input #: String
    .each_line.count do|input|
      width, height, *quantities = input.scan(/\d++/).map { Integer(it) } #: [Integer, Integer, Integer]
      if quantities.each_with_index.sum { counts.fetch(_2) * _1 } > width * height
        false
      elsif (width / size) * (height / size) < quantities.sum
        warn 'This region requires manual intervention:', input
      else
        true
      end
    end
)
