start = Time.now

input = File.open('inputs/13-sample.txt')
input = File.open('inputs/13.txt')

packets = []
input.each do |line|
  line.strip!
  next if line == ""
  eval "packets << #{line}" # much security
end

def compare_packets(left, right)
  # return true for good order, false for bad order
  # return up to check next part of packets
  return nil if left.empty? and right.empty?
  # is left or right empty?
  return true if left.empty?
  return false if right.empty?

  l = left[0]
  r = right[0]

  # this is jankier than shift/unshift, but doesn't modify the input arrays
  l_remain = left[1..-1]
  r_remain = right[1..-1]

  # both integers?
  if (l.is_a? Integer) && (r.is_a? Integer)
    return true if l < r
    return false if l > r
    return compare_packets(l_remain, r_remain)
  end

  # both arrays?
  if (l.is_a? Array) && (r.is_a? Array)
    result = compare_packets(l, r)
    # test next element if arrays are equal
    return compare_packets(l_remain, r_remain) if result.nil?
    return result
  end

  # left array, right int
  if l.is_a? Array
    return compare_packets(left, [[r]]+r_remain)
  end

  # left int, right array
  if r.is_a? Array
    return compare_packets([[l]]+l_remain, right)
  end
end

# part 1
correct_sum = 0
packets.each_slice(2).with_index do |pair, index|
  correct_sum += index + 1 if compare_packets(*pair)
end
puts correct_sum

# part 2
div_a = [[2]]
div_b = [[6]]
a_count = 1
b_count = 2 # b is bigger than a
packets.each do |packet|
  a_count += 1 if compare_packets(packet, div_a)
  b_count += 1 if compare_packets(packet, div_b)
end
puts a_count * b_count

puts "Time taken: #{Time.now - start}"
