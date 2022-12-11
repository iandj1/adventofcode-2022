start = Time.now

input = File.open('inputs/10-sample.txt')
input = File.open('inputs/10.txt')

instructions = []
input.each do |line|
  line.strip!
  instructions << 0
  if line != "noop"
    instructions <<  line.split(" ")[1].to_i
  end
end

clock = 0
signal = 0
x = 1
instructions.each do |instruction|
  crt_x = (clock % 40)
  puts if crt_x == 0
  clock += 1

  # part 1
  if (clock-20)%40 == 0
    signal += x * clock
  end
  
  # part 2
  if (crt_x - x).abs <=1
    print "█"
  else
    print " "
  end
  
  x += instruction
end
puts
puts signal

puts "Time taken: #{Time.now - start}"
