start = Time.now

input = File.open("inputs/7-sample.txt")
input = File.open("inputs/7.txt")

current_path = []
file_tree = {}

all_folder_paths = []

# build file tree
input.each do |line|
    line.strip!
    next if line == "$ ls"
    if line.start_with? "$"
        if line == "$ cd /"
            current_path = ["/"]
            file_tree["/"] = {}
        elsif line == "$ cd .."
            current_path.pop
        else
            dir_name = line.sub(/\$ cd /, "")
            file_tree.dig(*current_path)[dir_name] = {}
            current_path << dir_name
        end
        all_folder_paths << current_path.dup
    else
        dir = file_tree.dig(*current_path)
        size, filename = line.split(" ")
        dir[filename] = size.to_i
    end
end
all_folder_paths.uniq!

def size(folder)
    size = 0
    folder.each do |node, value|
        if value.is_a? Hash
            size += size(value)
        else
            size += value
        end
    end
    size
end

part1 = 0
all_folder_paths.each do |path|
    folder = file_tree.dig(*path)
    size = size(folder)
    if size <= 100000
        part1 += size
    end
end
puts part1 

total_space = 70000000
desired_space = 30000000
needed_space = size(file_tree) + desired_space - total_space
delete_candidate = []
all_folder_paths.each do |path|
    folder = file_tree.dig(*path)
    size = size(folder)
    if size >= needed_space
        delete_candidate << size
    end
end
puts delete_candidate.min

puts "Time taken: #{Time.now - start}"