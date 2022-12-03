require 'set'

start = Time.now

input = File.open("inputs/3-sample.txt")
input = File.open("inputs/3.txt")

counter = 0
rucksack_triples = []
triple = []
input.each do |line|
    line.strip!
    triple << line
    counter += 1
    if counter == 3
        rucksack_triples << triple
        triple = []
        counter = 0
    end
end

def priority(letter)
    if letter == letter.downcase
        letter.ord - 96
    else
        letter.ord - 38
    end
end

priorities = []

rucksack_triples.each do |triple|
    trip1 = Set.new(triple[0].split(""))
    trip2 = Set.new(triple[1].split(""))
    trip3 = Set.new(triple[2].split(""))
    all = (trip1 & trip2 & trip3).first
    priorities << priority(all)
end

puts priorities.sum

puts "Time taken: #{Time.now - start}"