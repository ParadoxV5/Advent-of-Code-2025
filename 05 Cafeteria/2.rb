# … but more accurately, interval merging day

ranges = ARGF.each_line(chomp: true).take_while { !it.empty? }.map do|range|
  range.split('-', 2).map { Integer(it) } #: [Integer, Integer]
end
ranges.sort_by! &:first # Sort by begins first

prev_end = -1
puts(ranges.sum do|next_begin, next_end|
  next 0 if next_end < prev_end
  next_exclusive_end = next_end.succ
  count = next_exclusive_end - [prev_end, next_begin].max
  prev_end = next_exclusive_end
  count
end)
