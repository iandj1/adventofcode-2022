start = Time.now

input = File.open("inputs/1-sample.txt")
input = File.open("inputs/1.txt")

elves = []
elf = []
input.each do |line|
    line.strip!
    if line.empty?
        elves << elf
        elf = []
    else
        elf << line.to_i
    end
end

totals = elves.map{ |elf| elf.sum }
puts totals.max

total = 0
3.times do
    max = totals.max
    total += max
    totals.delete(max)
end

puts total

puts "Time taken: #{Time.now - start}"