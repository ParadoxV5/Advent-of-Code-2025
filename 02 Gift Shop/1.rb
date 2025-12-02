# Since IDs don’t count leading zeroes, the ranges can imagine
# subdividing their IDs by their upper halves. Observations:
# * A subrange with odd number of digits cannot contain an invalid ID.
# * An _complete_ subrange with even number of digits (e.g., `ABC000-ABC999`)
#  has exactly one invalid ID (e.g., `ABCABC`).

puts(ARGF.each(',').sum do|input_range|
  input_range.chop! # Discard `,` or `\n`
  first_string, last_string =
    range_string = input_range.split('-') #: [String, String]
  first_length, last_length = range_string.map &:length #: [Integer, Integer]
  
  # Close the range in to a range of complete subranges and
  # count using the upper halves (2nd Observation point)
  (
    if first_length.odd?
      10 ** (first_length / 2)
    else
      half_length = first_length / 2
      upper = first_string[...half_length].to_i
      lower = first_string[half_length..].to_i
      # +1 if `"#{upper}#{upper}"` has already been passed
      upper += 1 if lower > upper
      upper
    end..if last_length.odd?
      10 ** (last_length / 2) - 1
    else
      half_length = last_length / 2
      upper = last_string[...half_length].to_i
      lower = last_string[half_length..].to_i
      # -1 if `"#{upper}#{upper}"` will never be reached
      # (`100… - 1`` is fine because the `99…` subrange has an odd no. of digits.)
      upper -= 1 if lower < upper
      upper
    end
  ).sum {|upper| Integer(upper.to_s * 2) }
end)
