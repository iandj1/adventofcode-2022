start = Time.now

input = File.open('inputs/18-sample.txt')
input = File.open('inputs/18.txt')

require 'set'

rock_coords = Set.new

input.each do |line|
  line.strip!
  rock_coords.add(line.split(',').map{|x| x.to_i})
end

min_x = rock_coords.map{|coord| coord[0]}.min
max_x = rock_coords.map{|coord| coord[0]}.max
min_y = rock_coords.map{|coord| coord[1]}.min
max_y = rock_coords.map{|coord| coord[1]}.max
min_z = rock_coords.map{|coord| coord[2]}.min
max_z = rock_coords.map{|coord| coord[2]}.max

def surface_area_coords(coords)
  exposed = 0
  air_coords = []
  coords.each do |coord|
    x,y,z = coord
    air_coords << [x+1,y,z] if !coords.include?([x+1,y,z])
    air_coords << [x-1,y,z] if !coords.include?([x-1,y,z])
    air_coords << [x,y+1,z] if !coords.include?([x,y+1,z])
    air_coords << [x,y-1,z] if !coords.include?([x,y-1,z])
    air_coords << [x,y,z+1] if !coords.include?([x,y,z+1])
    air_coords << [x,y,z-1] if !coords.include?([x,y,z-1])
  end
  air_coords
end

air_coords = surface_area_coords(rock_coords)
puts air_coords.length
air_coords = air_coords.to_set


while air_coords.size > 0
  bubble = Set.new
  bubble.add(air_coords.first)
  new_coords = bubble

  # grow bubble
  while true
    grow_coords = Set.new
    new_coords.each do |coord|
      x,y,z = coord
      grow_coords.add([x+1,y,z]) if !rock_coords.include?([x+1,y,z]) && !bubble.include?([x+1,y,z]) && !new_coords.include?([x+1,y,z])
      grow_coords.add([x-1,y,z]) if !rock_coords.include?([x-1,y,z]) && !bubble.include?([x-1,y,z]) && !new_coords.include?([x-1,y,z])
      grow_coords.add([x,y+1,z]) if !rock_coords.include?([x,y+1,z]) && !bubble.include?([x,y+1,z]) && !new_coords.include?([x,y+1,z])
      grow_coords.add([x,y-1,z]) if !rock_coords.include?([x,y-1,z]) && !bubble.include?([x,y-1,z]) && !new_coords.include?([x,y-1,z])
      grow_coords.add([x,y,z+1]) if !rock_coords.include?([x,y,z+1]) && !bubble.include?([x,y,z+1]) && !new_coords.include?([x,y,z+1])
      grow_coords.add([x,y,z-1]) if !rock_coords.include?([x,y,z-1]) && !bubble.include?([x,y,z-1]) && !new_coords.include?([x,y,z-1])
    end

    # inside rock
    if grow_coords.empty?
      rock_coords = rock_coords | bubble
      break
    end

    new_coords = grow_coords
    bubble = bubble | grow_coords

    # this 'bubble' is outside the rock
    break if new_coords.any?{|x,y,z| x<min_x || x>max_x || y<min_y || y>max_y || z<min_z || z>max_z}
  end
  air_coords = air_coords - bubble
end

pp surface_area_coords(rock_coords).length

puts "Time taken: #{Time.now - start}"