start = Time.now

input = File.open('inputs/14-sample.txt')
input = File.open('inputs/14.txt')

class Thing
  @@things = {} # [x,y] => type
  @@lowest_rock = -Float::INFINITY

  def initialize(x,y,type)
    @x = x
    @y = y
    @type = type
    @@things[[x,y]] = type
    @@lowest_rock = [y,@@lowest_rock].max if type == :rock
  end

  def self.all_things
    @@things
  end

  def self.map(floor = false)
    coords = @@things.keys
    min_x = coords.map{|coord| coord[0]}.min
    max_x = coords.map{|coord| coord[0]}.max
    min_y = coords.map{|coord| coord[1]}.min
    max_y = coords.map{|coord| coord[1]}.max
    (min_y..max_y).each do |y|
      (min_x..max_x).each do |x|
        case Thing.all_things[[x,y]]
        when :rock
          print('█')
        when :sand
          print('·')
        when nil
          print(' ')
        end
      end
      puts
    end
    puts '█'*(max_x - min_x + 1) if floor
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
        Thing.all_things[[@x,@y]] = @type
        return false if floor && @y == init_y
        return true
      end
      if @y == @@lowest_rock && !floor
        return false
      end
      if floor && @y == @@lowest_rock + 1
        Thing.all_things[[@x,@y]] = @type
        return true
      end
    end
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
        Thing.new(x,y,:rock)
      end
    end
  end
end

sand_spawn = [500,0]
floor = true

while true
  grain = Thing.new(*sand_spawn, :sand)
  break unless grain.fall(floor)
end

Thing.map(floor)

puts Thing.all_things.values.select{|type| type == :sand}.length

puts "Time taken: #{Time.now - start}"