start = Time.now

input = File.open('inputs/9-sample.txt')
input = File.open('inputs/9-sample2.txt')
input = File.open('inputs/9.txt')

class Coord
  attr_accessor :x, :y
  
  def initialize(x, y, child=nil)
    @x = x
    @y = y
    @child = child
  end
  
  def move(other)
    @x += other.x
    @y += other.y
    @child.pull(self)
  end

  def pull(new_coord)
    if self.distance(new_coord) > 1
      if @x < new_coord.x
        @x += 1
      elsif @x > new_coord.x
        @x -= 1
      end
      if @y < new_coord.y
        @y += 1
      elsif @y > new_coord.y
        @y -= 1
      end
    end
    @child.pull(self) if @child
  end
    
  def to_s
    "#{@x}, #{@y}"
  end

  def distance(other)
    [(x-other.x).abs, (y-other.y).abs].max
  end

  def tail
    @child&.tail || self
  end
end

movements = []
direction_map = {"R": Coord.new(1,0), "L": Coord.new(-1,0), "D": Coord.new(0,-1), "U": Coord.new(0,1)}
input.each do |line|
  line.strip!
  direction, distance = line.split(" ")
  distance.to_i.times do 
    movements << direction_map[direction.to_sym]
  end
end

rope1 = Coord.new(0,0)
rope1 = Coord.new(0,0,rope1)

rope2 = Coord.new(0,0)
9.times do
  rope2 = Coord.new(0,0,rope2)
end

positions1 = []
positions2 = []

movements.each do |movement|
  rope1.move(movement)
  rope2.move(movement)
  positions1 << rope1.tail.to_s
  positions2 << rope2.tail.to_s
end

puts positions1.uniq.length
puts positions2.uniq.length


puts "Time taken: #{Time.now - start}"
