def main_menu
  print "> "
  input = gets.chomp.downcase.split
  command = input[0]
  arg1 = input[1]

  case command
  when "add"
    if arg1 == "event"
      add_event(input[2])
    end
  when "help"
    help
  when "q"
    exit
  end
end

def help
  puts "Type 'add [event] [name] - to add an event'"
  puts "     'q'                 - to quit."
  print "\n"
end

def add_event(name)
  puts "#{name}> Please enter a description for the event:"
  description = gets.chomp

  puts "#{name}> Where is it?"
  location = gets.chomp

  puts "#{name}> What is the starting date?"
  start_date = gets.chomp
  puts "What is the starting time?"
  start_time = gets.chomp
  start_date = start_date + start_time

  puts "#{name}> What is the ending date?"
  end_date = gets.chomp
  puts "What time does it end?"
  end_time = gets.chomp
  end_date = end_date + end_time

  Event.create(:name => name, :description => description,
               :location => location, :start_date => date_time,
               :end_date => end_date)
end

puts " Calendar!"
puts "==========="

help
loop do
  main_menu
end
