PART2 = true
batteries_per_bank = PART2 ? 12 : 2

regexp = Regexp.compile(
  batteries_per_bank.times.reverse_each.map do|trailers|
    /(#{
      Regexp.union(
        *('0'..'9').each_cons(2).map { /#{_1}(?!.*?[#{_2}-9].{#{trailers}})/ },
        /9/
      )
    })/
  end.join '.*?'
)

puts(ARGF.each_line(chomp: true).sum do|bank|
  Integer(bank.match(regexp)&.captures&.join)
end)
