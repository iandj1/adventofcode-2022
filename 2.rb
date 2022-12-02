start = Time.now

input = File.open("inputs/2-sample.txt")
input = File.open("inputs/2.txt")

moves = []
input.each do |line|
    line.strip!
    moves << line.split(" ")
end

win = [["C", "X"], ["A", "Y"], ["B", "Z"]]
lose = [["B", "X"], ["C", "Y"], ["A", "Z"]]
draw = [["A", "X"], ["B", "Y"], ["C", "Z"]]


score = 0

moves.each do |move|
    if win.include? move
        score += win.index(move) + 1 + 6
    elsif draw.include? move
        score += draw.index(move) + 1 + 3
    elsif lose.include? move
        score += lose.index(move) + 1
    end
end

puts score

puts "Time taken: #{Time.now - start}"