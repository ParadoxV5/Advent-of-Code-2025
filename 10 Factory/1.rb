# * Use bits to make toggle computations easier: XOR → {Integer#^}
# * Lemma: Pressing a button twice gives the same effect as pressing it 0 times.

puts(ARGF.each_line.sum do|line|
  lights = Integer(
    line[/[.#]++/] #: String
      .tr('.#', '01').reverse, # Numbers assigns index 0 to the rightmost light.
  2)
  buttons = line.scan(/(?<=\()[\d,]++(?=\))/) #: Array[String]
    .map do|button|
      button.split(',').reduce(0) do|bitmap, bit_index|
        bitmap ^ (1 << Integer(bit_index))
      end
    end
  
  (1..buttons.size).find do|count|
    #TODO: caching XOR results can reduce unnecessary computations.
    # It’s okay here because the machines don’t have a lot of buttons each.
    buttons.combination(count).any? do|toggles|
      # x ^ y = 0 if and only if x = y
      toggles.inject(:^) == lights
    end
  end
end)
