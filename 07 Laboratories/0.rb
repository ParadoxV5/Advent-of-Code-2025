timelines =
  readline.each_char.with_index.filter_map {|c, i| [i, 1] if c == 'S' }.to_h
timelines.default = 0

puts(
  'Part 1',
  ARGF.each_line.sum do|line|
    splits = timelines.select {|space, _| line[space] == '^' }
    splits.each {|split, _| timelines.delete split } # {Enumerable#partition}
    splits.each do|split, weight|
      timelines[split.pred] += weight
      timelines[split.succ] += weight
    end
    splits.size
  end,
  'Part 2',
  timelines.sum { _2 }
)
