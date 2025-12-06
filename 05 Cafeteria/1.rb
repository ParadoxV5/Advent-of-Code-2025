# Day 5 is B-Search Day

ranges = ARGF.readline('', chomp: true).each_line(chomp: true).map do|range|
  range.split('-', 2).map { Integer(it) } #: [Integer, Integer]
end
ranges.sort_by! &:first # Sort by begins first

# Lightly merge ranges: Delete ranges that break the following
# `Array#bsearch` because they are `Range#cover?`ed in earlier ranges
prev_end = -1
ranges.keep_if {|_, range_end| prev_end = range_end if prev_end < range_end }

p(ARGF.each_line(chomp: true).count do|ingredient|
  id = Integer(ingredient)
  ranges.bsearch do|range_begin, range_end|
    # id <=> range
    if id < range_begin
      -1
    elsif id > range_end
      +1
    else
       0
    end
  end
end)
