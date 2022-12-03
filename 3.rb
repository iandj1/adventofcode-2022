require 'set'

start = Time.now

input = File.open("inputs/3-sample.txt")
input = File.open("inputs/3.txt")

rucksacks = []
rucksack_halves = []
input.each do |line|
    line.strip!
    rucksacks << line
    len = line.length
    rucksack_halves << [line[0,len/2], line[len/2, len/2]]
end

def priority(letter)
    if letter == letter.downcase
        letter.ord - 96
    else
        letter.ord - 38
    end
end

priorities = []

rucksack_halves.each do |triple|
    left = Set.new(triple[0].split(""))
    right = Set.new(triple[1].split(""))
    both = (left & right).first
    priorities << priority(both)
end

puts priorities.sum

puts "Time taken: #{Time.now - start}"