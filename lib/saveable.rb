require "yaml"
require "time"

# The Saveable module provides methods to save an object state and load it later.
module Saveable
  SAVE_FOLDER = "saves".freeze
  Dir.mkdir(SAVE_FOLDER) unless Dir.exist?(SAVE_FOLDER)

  def save_game
    content = instance_variables.each_with_object({}) do |var, hash|
      string_var = var.to_s.delete("@")

      hash[string_var] = instance_variable_get(var)
    end

    File.write("#{SAVE_FOLDER}/#{Time.new.strftime('%Y-%m-%d %H:%M:%S')}.yaml", YAML.dump(content))
  end

  def load_save?
    saves = Dir.children(SAVE_FOLDER)
    return if saves.empty?

    puts "\nThere are #{saves.length} save files available."

    loop do
      print "Do you want to load one of them? [y/N] "
      choice = gets.chomp.downcase

      break choice == "y" if %w[y n].include?(choice)

      puts "Please enter a valid input."
    end
  end

  def select_save
    saves = Dir.children(SAVE_FOLDER)

    saves.each_with_index do |save, index|
      puts "(#{index + 1}) #{save.sub('.yaml', '')}"
    end

    loop do
      print "Select a save to load.\n>> "
      choice = gets.chomp.to_i

      break saves[choice - 1] if (1..(saves.length)).include?(choice)

      puts "Please enter a valid input."
    end
  end

  def load_save(save)
    save_content = YAML.unsafe_load(File.read("#{SAVE_FOLDER}/#{save}"))

    save_content.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end
end
