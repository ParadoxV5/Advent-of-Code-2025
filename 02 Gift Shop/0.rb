# Take Part 1 for example – Since IDs don’t count leading zeroes, the ranges
# can imagine subdividing their IDs by their head halves. Observations:
# * A subrange with odd number of digits cannot contain an invalid ID.
# * An _complete_ subrange with even number of digits (e.g., `ABC000-ABC999`)
#   has exactly one invalid ID (e.g., `ABCABC`).

PART2 = true

puts(ARGF.each(',').sum do|range|
  range.chop! # Discard `,` or `\n`
  first, last = range.split('-') #: [String, String]
  (2..(PART2 ? last.length : 2)).sum do|repeat_count|
    #@type var head: String
    
    # Close the range in to a range of all complete subranges
    # and count using the head part (2nd Observation point)
    head_length, length_modulus = first.length.divmod repeat_count
    first_head = if length_modulus.zero?
      head = first[...head_length] #: String
      head_num = Integer(head)
      # next subrange if the invalid ID of the subrange has already been passed
      head_num += 1 if Integer(first) > Integer(head * repeat_count)
      head_num
    else
      10 ** head_length # next number of digits
    end
    head_length, length_modulus = last.length.divmod repeat_count
    last_head = if length_modulus.zero?
      head = last[...head_length] #: String
      head_num = Integer(head)
      # previous subrange if the invalid ID of the subrange won't be reached
      # (`100… - 1` is fine because the nearby `99…` subrange has extra digits.)
      head_num -= 1 if Integer(last) < Integer(head * repeat_count)
      head_num
    else
      10 ** head_length - 1 # previous number of digits
    end

    # Now, generate the sequence
    (first_head..last_head).sum do|head_num|
      head = head_num.to_s
      # To avoid double counting, skip `head`s that are themselves invalid
      if PART2 and head.match? /\A(.+?)\1+\z/
        0
      else
        Integer(head.to_s * repeat_count)
      end
    end
  end
end)
