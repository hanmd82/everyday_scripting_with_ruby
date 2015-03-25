def month_before(a_time)
  a_time - 28 * 24 * 60 * 60
end

def svn_date(a_time)
  a_time.strftime("%Y-%m-%d")
end

def header(an_svn_date)
  "Changes between #{an_svn_date} and #{svn_date(Time.now)}:"
end

def subsystem_line(subsystem_name, change_count)
  asterisks = asterisks_for(change_count)
  changes = (asterisks == "") ? "-" : "(#{change_count} changes)  #{asterisks}"
  "#{subsystem_name.ljust(14)}  #{changes}"
end

def asterisks_for(an_integer)
  (an_integer == 1 || an_integer == 2) ? '*' : '*' * (an_integer / 5.0).round
end

def change_count_for(name, start_date)
  extract_change_count_from(svn_log(name, start_date))
end

def extract_change_count_from(log_text)
  lines = log_text.split("\n")
  dashed_lines = lines.find_all do |line|
    line.include?('--------')
  end
  dashed_lines.length - 1
end

def svn_log(subsystem, start_date)
  timespan = "--revision 'HEAD:{#{start_date}}'"
  root = "svn://rubyforge.org//var/svn/churn-demo"

  `svn log #{timespan} #{root}/#{subsystem}`
end

def churn_line_to_int(line)
  /\((\d+) (\w+)\)/.match(line)[1].to_i
end

def order_by_descending_change_count(lines)
  lines.sort do |one, another|
    one_count = churn_line_to_int(one)
    another_count = churn_line_to_int(another)
    - (one_count <=> another_count)
  end
end

if $0 == __FILE__
  subsystem_names = ['audit', 'fulfillment', 'persistence',
                     'ui', 'util', 'inventory']
  start_date = svn_date(month_before(Time.local(1997, 4, 1)))

  puts header(start_date)
  lines = subsystem_names.collect do | name |
    subsystem_line(name, change_count_for(name, start_date))
  end
  puts order_by_descending_change_count(lines)
end
