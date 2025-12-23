PART2 = true
batteries_per_bank = PART2 ? 12 : 2

puts(ARGF.each_line(chomp: true).sum do|bank|
  digits = bank.slice!(-batteries_per_bank..) #: String
  # Note: {Enumerable#max} would give `98` for `892`
  bank.each_char.reverse_each do|battery|
    if battery >= digits[0]
      # Find the most wasted high place value
      index = digits.each_char
        .each_cons(2) #: Enumerator[[String, String], bot]
        .find_index { _1 < _2 } || ~0
      digits[1..index] = (
        digits[...index] #: String
      )
      digits[0] = battery
    end
  end
  Integer(digits)
end)
