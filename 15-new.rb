start = Time.now

input = File.open('inputs/15-sample.txt')
input = File.open('inputs/15.txt')

def calc_distance(coord1, coord2)
  (coord1[0]-coord2[0]).abs + (coord1[1]-coord2[1]).abs
end

sensors = {}
beacons = []

input.each do |line|
  line.strip!
  match = line.match(/x=(?<s_x>[\d-]+), y=(?<s_y>[\d-]+).*x=(?<b_x>[\d-]+), y=(?<b_y>[\d-]+)/)
  sensor = [match[:s_x].to_i, match[:s_y].to_i]
  beacon = [match[:b_x].to_i, match[:b_y].to_i]

  distance = calc_distance(sensor, beacon)
  sensors[sensor] = distance
  beacons << beacon
end
beacons.uniq!

def combine_ranges(ranges)
  ranges.sort!{|a,b| a.first <=> b.first}
  new_ranges = []
  while !ranges.empty?
    if ranges.length > 1 && ranges[0].last + 1 >= ranges[1].first #overlap
      ranges[1] = (ranges[0].first..[ranges[0].last,ranges[1].last].max)
      ranges.shift
    else
      new_ranges << ranges.shift
    end
  end
  new_ranges
end

def range_at_y(sensor, distance, row)
  half_length = distance - (sensor[1] - row).abs
  return nil if half_length < 0
  (sensor[0]-half_length..sensor[0]+half_length)
end


def covered_ranges(row, sensors)
  ranges = []
  sensors.each do |sensor, distance|
    range = range_at_y(sensor, distance, row)
    ranges << range if !range.nil?
  end
  ranges
end

# part 1
y = 2000000
total_positions = combine_ranges(covered_ranges(y, sensors)).map{|range| range.size}.sum
beacons_in_row = beacons.select{|beacon| beacon[1] == y}.size
puts total_positions - beacons_in_row

# part 2
rows = (0..4000000)
rows.each do |y|
  covered_ranges = combine_ranges(covered_ranges(y, sensors))
  if covered_ranges.length == 2
    puts "found hole at #{y}: #{covered_ranges}"
    puts (covered_ranges[0].last+1)*4000000 + y
    break
  end
end

puts "Time taken: #{Time.now - start}"