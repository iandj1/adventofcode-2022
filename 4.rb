start = Time.now

input = File.open("inputs/4-sample.txt")
input = File.open("inputs/4.txt")

def range_contains(a, b)
    if a.include?(b.first) && a.include?(b.last)
        true
    elsif b.include?(a.first) && b.include?(a.last)
        true
    else
        false
    end
end

def range_overlaps(a, b)
    if a.include?(b.first) || a.include?(b.last)
        true
    elsif b.include?(a.first) || b.include?(a.last)
        true
    else
        false
    end
end

full_overlap_count = 0
overlap_count = 0

input.each do |line|
    line.strip!
    elf_pair = []
    line.split(",").each do |elf|
        range = elf.split("-")
        range = range[0].to_i..range[1].to_i
        elf_pair << range
    end
    if range_contains *elf_pair
        full_overlap_count += 1
    end
    if range_overlaps *elf_pair
        overlap_count += 1
    end
end

puts full_overlap_count
puts overlap_count

puts "Time taken: #{Time.now - start}"