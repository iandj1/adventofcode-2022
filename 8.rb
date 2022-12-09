start = Time.now

input = File.open('inputs/8-sample.txt')
input = File.open('inputs/8.txt')

trees_xy = []
trees_yx = []

input.each_with_index do |line, y|
  line.strip!
  line.split('').each_with_index do |height, x|
    trees_xy[x] ||= []
    trees_xy[x][y] = height.to_i
    trees_yx[y] ||= []
    trees_yx[y][x] = height.to_i
  end
end

def find_viewing_distance(height, trees)
  dist = trees.length
  trees.each_with_index do |other_height, index|
    if height <= other_height
      dist = index + 1
      break
    end
  end
  dist
end

n_visible = 0
best_score = 0
trees_xy.each_index do |x|
  trees_xy[x].each_index do |y|
    visible = false
    score = 1
    height = trees_xy[x][y]
    # north
    north_trees = trees_xy[x].select.with_index { |_, other_y| other_y < y }.reverse
    visible ||= north_trees.all? { |other_h| other_h < height }
    score *= find_viewing_distance(height, north_trees)
    # south
    south_trees = trees_xy[x].select.with_index { |_, other_y| other_y > y }
    visible ||= south_trees.all? { |other_h| other_h < height }
    score *= find_viewing_distance(height, south_trees)
    # west
    west_trees = trees_yx[y].select.with_index { |_, other_x| other_x < x }.reverse
    visible ||= west_trees.all? { |other_h| other_h < height }
    score *= find_viewing_distance(height, west_trees)
    # east
    east_trees = trees_yx[y].select.with_index { |_, other_x| other_x > x }
    visible ||= east_trees.all? { |other_h| other_h < height }
    score *= find_viewing_distance(height, east_trees)

    n_visible += 1 if visible
    best_score = [score, best_score].max
  end
end
puts n_visible
puts best_score

puts "Time taken: #{Time.now - start}"
