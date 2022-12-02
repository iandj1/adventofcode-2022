start = Time.now

input = File.open("inputs/2-sample.txt")
input = File.open("inputs/2.txt")

moves = []
input.each do |line|
    line.strip!
    moves << line.split(" ")
end

# A for Rock
# B for Paper
# C for Scissors

# moves
#draw = [["A", "A"], ["B", "B"], ["C", "C"]]
#lose = [["B", "A"], ["C", "B"], ["A", "C"]]
#win = [["C", "A"], ["A", "B"], ["B", "C"]]

draw = ["A", "B", "C"]
lose = ["B", "C", "A"]
win = ["C", "A", "B"]


score = 0

moves.each do |move|
    them, outcome = move
    if outcome == "X" # lose
        score += lose.index(them) + 1
    elsif outcome == "Y" # draw
        score += draw.index(them) + 1 + 3
    elsif outcome == "Z" # win
        score += win.index(them) + 1 + 6
    end
end

puts score

puts "Time taken: #{Time.now - start}"