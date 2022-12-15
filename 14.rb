start = Time.now

input = File.open('inputs/14-sample.txt')
input = File.open('inputs/14.txt')

class Thing
  @@things = {} # [x,y] => Thing

  def initialize(x,y)
    @x = x
    @y = y
    @@things[[x,y]] = self
  end

  def self.all_things
    @@things
  end

  def self.map
    coords = @@things.keys
    min_x = coords.map{|coord| coord[0]}.min
    max_x = coords.map{|coord| coord[0]}.max
    min_y = coords.map{|coord| coord[1]}.min
    max_y = coords.map{|coord| coord[1]}.max
    (min_y..max_y).each do |y|
      (min_x..max_x).each do |x|
        if Thing.all_things.include?([x,y])
          print(Thing.all_things[[x,y]].symbol)
        else
          print(' ')
        end
      end
      puts
    end
  end
end

class Sand < Thing
  @@grains = 0
  def symbol
    "·"
  end

  def initialize(x,y)
    super
    @@grains += 1
  end

  def self.grains
    @@grains
  end

  def fall(floor = false)
    init_y = @y
    Thing.all_things.delete([@x, @y])
    while true
      if !Thing.all_things.include? [@x, @y+1]
        @y = @y+1
      elsif !Thing.all_things.include? [@x-1, @y+1]
        @x = @x-1
        @y = @y+1
      elsif !Thing.all_things.include? [@x+1, @y+1]
        @x = @x+1
        @y = @y+1
      else
        # stopped
        Thing.all_things[[@x,@y]] = self
        return false if floor && @y == init_y
        return true
      end
      if @y == Wall.lowest_wall && !floor
        @@grains -= 1
        return false
      end
      if floor && @y == Wall.lowest_wall + 1
        Thing.all_things[[@x,@y]] = self
        return true
      end
    end
  end
end

class Wall < Thing
  @@lowest_wall = -Float::INFINITY
  def initialize(x,y)
    super
    @@lowest_wall = [y,@@lowest_wall].max
  end

  def self.lowest_wall
    return @@lowest_wall
  end
  
  def symbol
    "█"
  end
end

input.each do |line|
  line.strip!
  # pp line
  line.scan(/(?=(\b\d+,\d+) -> (\d+,\d+\b))/).each do |match|
    from, to = match
    # pp match
    from_x, from_y = from.split(",").map{|x| x.to_i}
    to_x, to_y = to.split(",").map{|x| x.to_i}
    if to_x < from_x || to_y < from_y
      to_x, to_y, from_x, from_y = from_x, from_y, to_x, to_y
    end
    (from_x..to_x).each do |x|
      (from_y..to_y).each do |y|
        Wall.new(x,y)
      end
    end
  end
end

# pp Thing.all_things
# Thing.map

sand_spawn = [500,0]

while true
  grain = Sand.new(*sand_spawn)
  break unless grain.fall(false)
  # Thing.map
end

Thing.map
puts Sand.grains

puts "Time taken: #{Time.now - start}"