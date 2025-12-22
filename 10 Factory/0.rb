# ### Part 1
# * Use bits to make toggle computations easier: XOR → {Integer#^}
# * Lemma: Pressing a button twice gives the same effect as pressing it 0 times.
# 
# ### Part 2
# Most people simply reached for
# [Z3](https://en.wikipedia.org/wiki/Z3_Theorem_Prover)…
# But, after days of scratching my head at an implementation of
# https://en.wikipedia.org/wiki/System_of_linear_equations#Row_reduction
# (incomplete; shelved),
# I realized the hard way that it is __never__ the intended solution,
# not to mention Part 1’s appearent lack of purpose in this approach.
# Instead, {#bifurcate} is an implementation of
# https://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/ –
# credits to them for sharing what’s likely the intended strategy.
# The XOR indexing is kept here to speed up searching

def joltages2lights(joltages) = joltages.map { it.odd? ? '#' : '.' }.join
def bifurcate(joltages, combinations)
  return if joltages.any?(&:negative?)
  return 0 if joltages.all?(&:zero?)

  candidates = combinations[joltages2lights joltages]
  candidates.lazy.filter_map do|count, joltages2|
    count2 = bifurcate(
      [joltages, joltages2].transpose.map { (_1 - _2) / 2 },
      combinations
    )
    count2 * 2 + count if count2
  end.min if candidates
end

puts(ARGF.each_line.sum do|line|
  lights = line[/[.#]++/] #: String
  buttons = line.scan(/(?<=\()[\d,]++(?=\))/) #: Array[String]
    .map {|button| button.split(',').map { Integer(it) } }
  joltages = line[/(?<=\{)[\d,]++(?=\})/] #: String
    .split(',').map { Integer(it) }
  
  # Yes, the `0` is a missable candidate.
  combinations = (0..buttons.size).flat_map do|count|
    #TODO: caching sum results can reduce unnecessary computations.
    # It’s okay here because the machines don’t have a lot of buttons each.
    buttons.combination(count).map do|selection|
      [
        count,
        selection.each_with_object(
          Array.new(joltages.size, 0) #: joltages
        ) {|button, joltages2| button.each { joltages2[it] += 1 } }
      ] #: combination
    end
  # Keep all combinations because the candidate with the least
  # presses may not be the overall optimal or even overshoot
  end.group_by { joltages2lights _2 } #: combinations
  
  Complex.rect(
    combinations.fetch(lights).map(&:first).min,
    bifurcate(joltages, combinations) #: Integer
  )
end.rect)
