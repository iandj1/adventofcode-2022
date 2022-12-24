start = Time.now

require 'symbolic'

input = File.open('inputs/21-sample.txt')
input = File.open('inputs/21.txt')

monkeys = {} # monkey => formula
references = {} # monkey => [monkeys referencing this monkey]
known_monkeys = []

input.each do |line|
  line = line.strip.split(": ")
  monkeys[line[0]] = line[1]
end

# part 2
monkeys['humn'] = 'x'
monkeys['root'].gsub!("+", "==")

monkeys.each do |monkey, formula|
  refs = formula.scan(/[a-z]{4}/)
  if refs.empty?
    known_monkeys << monkey
    next
  end
  refs.each do |ref_monkey|
    references[ref_monkey] ||= []
    references[ref_monkey] << monkey
  end
end

while !known_monkeys.empty?
# while known_monkeys != ["root"]
  km = known_monkeys.shift
  references[km]&.each do |ref_monkey|
    monkeys[ref_monkey].gsub!(km, "(#{monkeys[km]})")
    if !(/[a-z]{4}/ =~ monkeys[ref_monkey])
      known_monkeys << ref_monkey
    end
  end
end

#solve right
pp eval monkeys["root"].split("==")[1]

#simplify left
x = var :name => 'x'
pp eval monkeys["root"].split("==")[0]

puts "Time taken: #{Time.now - start}"

# a bit manual, but it works
puts (((49160133593649*2)-1546041830180172/7)/(-34.91428571428571)).round