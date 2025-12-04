grid = [
  *ARGF.readlines,
  '' # convenience padding
]

puts(grid.each_with_index.sum do|row, y|
  row.each_char.with_index.count do|cell, x|
    cell == '@' and [
      grid[y+1][x  ],
      grid[y+1][x+1],
      row      [x+1],
      grid[y-1][x+1],
      grid[y-1][x  ],
      grid[y-1][x-1],
      row      [x-1],
      grid[y+1][x-1]
    ].count('@') < 4
  end
end)
