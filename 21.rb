start = Time.now

input = File.open('inputs/21-sample.txt')
input = File.open('inputs/21.txt')

monkeys = {} # monkey => formula
references = {} # monkey => [monkeys referencing this monkey]
known_monkeys = []

input.each do |line|
  line = line.strip.split(": ")
  monkeys[line[0]] = line[1]
end

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

pp eval monkeys["root"]

puts "Time taken: #{Time.now - start}"