start = Time.now

input = File.open('inputs/11-sample.txt')
input = File.open('inputs/11.txt')

class Monkey
  @@monkeys = []
  @@modulo_product = 1

  attr_accessor :inspect_count
  
  def initialize(items, operation, divisor, t_monkey, f_monkey)
    @items = items
    @operation = operation
    @divisor = divisor
    @@modulo_product *= divisor
    @t_monkey = t_monkey
    @f_monkey = f_monkey
    @@monkeys << self
    @inspect_count = 0
  end

  def take_turn(divide_3)
    while !@items.empty?
      @inspect_count += 1
      item = @items.shift
      item = @operation.call(item)
      item = item / 3 if divide_3
      item = item % @@modulo_product
      monkey = item % @divisor == 0 ? @t_monkey : @f_monkey
      self.class.get_monkey(monkey).catch(item)
    end
  end

  def catch(item)
    @items << item
  end

  def self.get_monkey(monkey_id)
    @@monkeys[monkey_id]
  end

  def self.list
    @@monkeys
  end

  def self.list_activity
    self.list.map{ |monkey| monkey.inspect_count}
  end
end

# create monkeys
input.read.split("Monkey").each do |monkey|
  next if monkey == ""
  match = monkey.match(/items: ((\d+(, )?)+)/)
  items =  match[1].split(", ").map{|item| item.to_i}
  match = monkey.match(/new = (.+)/)
  operation = eval "lambda {|old| #{match[1]}}"
  match = monkey.match(/divisible by (\d+)/)
  divisor = match[1].to_i
  match = monkey.match(/true: throw to monkey (\d+)/)
  t_monkey = match[1].to_i
  match = monkey.match(/false: throw to monkey (\d+)/)
  f_monkey = match[1].to_i
  Monkey.new(items, operation, divisor, t_monkey, f_monkey)
end

rounds = 10000
rounds.times do |index|
  Monkey.list.each do |monkey|
    monkey.take_turn(false)
  end
end

puts Monkey.list_activity.sort[-2,2].inject(:*)

puts "Time taken: #{Time.now - start}"
