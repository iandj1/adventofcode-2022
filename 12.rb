start = Time.now

input = File.open('inputs/12-sample.txt')
input = File.open('inputs/12.txt')

height_map = []
start_xy = nil
end_xy = nil
possible_starts = []
input.each_with_index do |line, index|
  line.strip!
  start_xy = [index, line.index("S")] if line.include? "S"
  end_xy = [index, line.index("E")] if line.include? "E"
  line.tr!('SE', 'az')
  height_map << line.split("")
  height_map[-1].each_with_index do |height, index2|
    possible_starts << [index, index2] if height == 'a'
  end
end


def get_neighbours(coord, limits)
  x,y = coord
  xlim, ylim = limits
  neighbours = []
  if x != 0
    neighbours << [x-1, y]
  end
  if x != xlim
    neighbours << [x+1, y]
  end
  if y != 0
    neighbours << [x, y-1]
  end
  if y != ylim
    neighbours << [x, y+1]
  end
  neighbours
end

def path_length(start_xy, end_xy, height_map)
  limits = [height_map.length-1, height_map[0].length-1]
  just_visited = start_xy
  all_visited = {} # coord: steps taken
  start_xy.map{|coord| all_visited[coord] = 0}
  
  while true
    next_visit = []
    just_visited.each do |visited_coord|
      steps = all_visited[visited_coord] + 1
      get_neighbours(visited_coord, limits).each do |coord|
        next if all_visited.include? coord
        # check if neighbour is climbable
        next if height_map.dig(*coord).ord - height_map.dig(*visited_coord).ord > 1
        return steps if coord == end_xy
        all_visited[coord] = steps
        next_visit << coord
      end
    end
    just_visited = next_visit
    return nil if just_visited == [] # can't reach finish from this starting point
  end
end

puts path_length([start_xy], end_xy, height_map)
# puts possible_starts.map{|start| path_length([start], end_xy, height_map)}.compact.min
puts path_length(possible_starts, end_xy, height_map) # way faster way to do part 2, borrowed from reddit

puts "Time taken: #{Time.now - start}"