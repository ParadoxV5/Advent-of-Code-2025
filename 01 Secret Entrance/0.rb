# Reference: https://math.stackexchange.com/a/1867261
# When turning `L`eft, instead of adjusting by 1 for the edge cases at `0`,
# this implementation uses negated Integer#divmod to demonstrate understanding.

part1 = part2 = 0
dial = 50

ARGF.each_line do|rotation|
  direction, distance = rotation.split '', 2
  negate = direction == 'L'
  delta = Integer(distance)
  
  # Normalize the previous `dial` state first to match the current direction
  zero_clicks, dial = if negate
    dial -= 100 if dial.positive?
    (dial - delta).divmod -100
  else
    dial += 100 if dial.negative?
    (dial + delta).divmod +100
  end

  part1 += 1 if dial.zero?
  part2 += zero_clicks
end
puts part1:, part2:
