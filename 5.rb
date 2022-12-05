start = Time.now

input = File.open("inputs/5-sample.txt")
input = File.open("inputs/5.txt")

stack = {}
# read stack
input.each do |line|
    break if line.strip == ""
    row = line.gsub(/.(.).[\S\s]/,'\1-').gsub(/-$/,'').split('-')
    next if row[0] == '1'
    row.each_with_index do |crate, column|
        next if crate == " "
        stack[column+1] ||= []
        stack[column+1].unshift(crate)
    end
end

# is this really the best way to deep copy in ruby???
stack2 = Marshal.load(Marshal.dump(stack))

# read instructions
input.each do |line|
    match = line.match(/move (?<n>\d+) from (?<from>\d+) to (?<to>\d+)/)
    from = match[:from].to_i
    to = match[:to].to_i
    n = match[:n].to_i
    n.times do
        stack[to] << stack[from].pop
    end
    stack2[to].concat(stack2[from].pop(n))
end

# get output
(1..stack.length).step do |n|
    print stack[n].last
end
puts
(1..stack2.length).step do |n|
    print stack2[n].last
end
puts

puts "Time taken: #{Time.now - start}"