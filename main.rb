require 'active_record'
require './lib/event'
require "./lib/todo"
require "pry"

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def main_menu
  print "> "
  input = gets.chomp.downcase.split
  command = input[0]
  arg1 = input[1]

  case command
  when "add"
    if arg1 == "event"
      add_event(input[2])
    elsif arg1 == "todo"
      add_todo(input[2], input[3..-1]*"")
    elsif arg1 == "note"
      add_note(input[2])
    end
  when "view"
    if arg1 == "event"
      view_events(input[2])
    elsif arg1 == "day"
      view_date(input[2])
    elsif arg1 == "week"
      view_week
    elsif arg1 == "month"
      view_month(input[2])
    elsif arg1 == "todo"
      view_todo
    else
      "wat"
    end
  when "delete"
    if arg1 == "event"
      delete_event(input[2])
    elsif arg1 == "todo"
      system 'clear'
      puts "error."
    end
  when 'update'
    update_event(input[1])
  when "help"
    help
  when "q"
    exit
  end
end

def help
  puts "Type add event [name]             - to add an event"
  puts "         note  [event/todo][name] - to add a note to an event"
  puts "         todo  [name][to do]      - to add a todo thing\n\n"
  puts "     view event                   - to see all events, or specify one event."
  puts "          day [day]               - to list the day"
  puts "          month [month]           - to list month"
  puts "          week                    - to list current week\n\n"
  puts "     update [name]                - to update an event."
  puts "     delete [event] [name]        - to delete an event."
  puts "     q                            - to quit."
  puts "     help                         - to reprint this menu"
  print "\n"
end

def add_event(name)
  fields = %w(description location start_date start_time end_date end_time)
  info = {name: name}

  fields.each do |field|
    print "#{field}: "
    info[:"#{field}"] = gets.chomp
  end

  puts info

  info[:start_date] = Time.parse(info[:start_date] + info[:start_time])
  info[:end_date] = Time.parse(info[:end_date] + info[:end_time])

  info.delete(:start_time)
  info.delete(:end_time)

  Event.create(info)
end

def add_todo(name, description)
  Todo.create(task: name, description: description)
end

def view_todo
  Todo.all.each{|todo| puts "#{todo.task} - #{todo.description}"}
end

def del_todo(name)
  Todo.find_by(task: name).destroy
end

def add_note(note)

end

def view_events(event_name)
  if event_name.blank?
    Event.order("start_date").each { |e| puts "#{e.name} - #{e.start_date}" }
  else
    current_event = Event.find_by(name: event_name)
    puts "#{current_event.name}"
    print "=" * current_event.name.length
    puts "\n#{current_event.location}"
    puts "#{current_event.description}"
    puts "#{current_event.start_date} - #{current_event.end_date}"
    puts "(event created at #{current_event.created_at})"
  end
end

def view_date(date)
  date = Date.parse(date)
  events = Event.where(:start_date => date..date.next)

  events.each{|event| puts event.name}
end

def view_week
  date = Date.today

  until date.sunday?
    date = date.prev_day
  end

  events = Event.where(:start_date => date..date + 7)

  events.each{|event| puts event.name}
end

def view_month(date)
  date = Date.parse(date)
  events = Event.where(:start_date => date..date.next_month)

  events.each{|event| puts event.name}
end

def delete_events(event_name)
  Event.find_by(name: event_name).destroy
end

def update_event(event_name)
  current_event = Event.find_by(name: event_name)
  view_events(event_name)

  puts "What would you like to update?"
  puts ["name", "description", "location", "start_date", "end_date"]
  to_update = gets.chomp

  puts "What should #{to_update} be?"
  print ">> "
  updated_info = gets.chomp

  current_event.update(:"#{to_update}" => updated_info)
end

puts " Calendar!"
puts "==========="

help

loop do
  main_menu
end
