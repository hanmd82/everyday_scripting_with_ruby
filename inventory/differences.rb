def check_usage
  unless ARGV.length == 2
    puts "Usage: differences.rb first_filename second_filename"
    exit
  end
end

def contains?(line, key)
  line.split('/').include?(key)
end

def boring?(line, keys)
  chompedline = line.chomp
  keys.any? { |key| contains?(chompedline, key) }
end

def inventory_from(filename)
  inventory = File.open(filename)
  downcased = inventory.collect { |line| line.downcase }
  downcased.reject { |line| boring?(line, ['temp', 'recycler']) }
end

def compare_inventory_files(old_file, new_file)
  old_inventory = inventory_from(old_file)
  new_inventory = inventory_from(new_file)

  puts "The following files have been added:"
  puts new_inventory - old_inventory

  puts ""
  puts "The following files have been deleted:"
  puts old_inventory - new_inventory
end

if $0 == __FILE__
  check_usage
  compare_inventory_files(ARGV[0], ARGV[1])
end
