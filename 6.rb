start = Time.now

input = File.open("inputs/6-sample.txt")
input = File.open("inputs/6.txt")

buffer = input.read.strip

def find_uniq_index(buffer, n)
    (0...buffer.length-n).each do |i|
        if buffer[i,n].split("").uniq.length == n
            return i+n
        end
    end
end

puts find_uniq_index(buffer, 4)
puts find_uniq_index(buffer, 14)

puts "Time taken: #{Time.now - start}"