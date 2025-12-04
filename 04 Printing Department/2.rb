# `until part1().zero? do end`?
# Here’s a version based on an unvisited set.
# 
# It’s inspired by the TriColor Marking algorithm as used in CRuby’s GC.
# The highlight is:
# One (multi-root) traversal pass is not enough for a non-blocking GC –
# Already marked objects needs to return to the unvisited set upon
# modification in case the changes releases some of their references.

to_check = Set.new #$ [Integer, Integer]
grid = [
  *ARGF.each_line.with_index.map do|row, y|
    row.each_char.with_index.map do|cell, x|
      to_check << [x, y] if cell == '@'
      # `nil` = Nothing here (or OOB) or roll already removed
    end
  end,
  [] # convenience padding
] #: Array[Array[boolish]]
puts to_check.size if $DEBUG

rolls_removed = 0
to_check = to_check.each_with_object(Set.new) do|(x, y), to_check2|
  if grid[y][x]
    roll_xys = [
      [x  , y+1],
      [x+1, y+1],
      [x+1, y  ],
      [x+1, y-1],
      [x  , y-1],
      [x-1, y-1],
      [x-1, y  ],
      [x-1, y+1]
    ] #: Array[[Integer, Integer]]
      .select { grid[_2][_1] }
    if roll_xys.size < 4
      grid[y][x] = nil
      rolls_removed += 1
      to_check2.merge roll_xys # Ripple update (as in unmarking)
    end
  end
end until to_check.size.zero?

if $DEBUG
  grid.each do|row|
    row.each { print it ? '@' : '.' }
    puts
  end
end
puts rolls_removed
