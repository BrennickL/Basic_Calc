# @author Brennick Langston
# @version 1.0.0
# @todo History Collector
# @todo Functions

# Displays the Main Menu
# @return
def display_menu
  puts "\n\nMain Menu"
  puts '1) Enter Variables'
  puts '2) Enter Search String'
  puts '3) Show History'
  puts '0) Quit'
  select_option
end

# Obtains an option selected from the user
# @return nil
def select_option
  puts "Enter Option:\s"
  option = gets.strip
  process_option(option)
end

# Determines which subapplication should be run
# @param option <String> user selected input option
# @return nil
def process_option(option)
  case option.to_f
  when 1
    show_variable_menu
  when 2
    show_eq_menu
  when 3
    show_eq_history
  when 0
    exit_application
  else
    show_error_menu
  end
end

# Exits the application
# @return nil
def exit_application
  puts "\n\nExiting application!"
  exit
end

# Displays the error menu for invalid user input variables
# @return nil
def show_error_menu
  puts "\n\nInvalid Input! Please try again."
  display_menu
end

# Displays the menu for getting user variables as input
# @return nil
def show_variable_menu
  print "First Variable:\s"
  var1 = gets.strip
  print "Operator:\s"
  op = gets.strip
  print "Second Variable:\s"
  var2 = gets.strip
  check_var_inputs(var1, op, var2)
  calculate_vars(var1, op, var2)
end

# Checks the validity of the input variables
# @param var1 <String> left hand equation variable
# @param op <String> operator for calculations
# @param var2 <String> Right hand equation variable
# @return nil
def check_var_inputs(var1, op, var2)
  check_num_inputs(var1, var2)
  show_error_menu unless op !~ /[0-9a-zA-Z]+/
end

# Check the valididty of the user numeric input Variables
# @param var1 <String> left hand variable
# @param var2 <String> Right hand variable
# @return nil
def check_num_inputs(var1, var2)
  show_error_menu if var1 =~ /[a-zA-Z]+/
  show_error_menu if var2 =~ /[a-zA-Z]+/
end

# Does calculations using the user input variables that were submitted
# @param var1 <String> left hand equation variable
# @param op <String> operator for calculations
# @param var2 <String> Right hand equation variable
# @return nil
def calculate_vars(var1, op, var2)
  ans = var1.to_f.send(op, var2.to_f)
  if !ans.nil?
    printf("Calculated Answer:\s%3.3f\n", ans)
  else
    show_error_menu
  end
  display_menu
end

# Displays the menu for acquiring a string equation
# @return nil
def show_eq_menu
  puts "Enter an equation like [5-7+3+(10*10)+(20+20)]:\s"
  eq = gets.strip
  parse_eq_string(eq)
  puts "Answer:\s#{eq}"
  display_menu
end

# Parser for equations submitted as strings
# @param str <String> simple equation
# @return <String> reduced answer
def parse_eq_string(str)
  eq = str
  parse_eq_parens(str)
  ans = str
  @history[eq] = ans
end

# Parse embeded parenthesis and do calculations
# @param str <String> string or substring of the equation
# @return nil
def parse_eq_parens(str)
  until str.empty?
    pre_length = str.length
    # obtain everything inside parens as one string
    str.gsub!(/(\([^\(|\)]*\))/) do |group|
      parse_eq_emdas(group)
      group.gsub!(/[\(|\[|\]|\)]/){ '' }
      puts "Group: #{group}"
      group
    end
    break if pre_length == str.length
  end
  parse_eq_remove_negs(str)
end

# Handler for any trailing or double negative operators
# @param str <String> string representing an equation fragment
# @return nil
def parse_eq_remove_negs(str)
  ['\*', '\/', '\+', '\-'].each do |op|
    until str.empty?
      pre_length = str.length
      # do calculations
      # <Floats> are inserted into the string from EMDAS
      str.gsub!(/([\-]?\d+\.\d*?)([#{op}])([\-]?\d+\.\d*?)/) do
        var1, op, var2 = $1, $2, $3
        puts "Negatives:\s#{str} :#{$&}"
        ans = var1.to_f.send(op, var2.to_f)
        ans
      end
      break if pre_length == str.length
    end
  end
end # parse_eq_remove_negs

# Parse the embeded equation w/out parens according to PEMDAS
# @param group <String> substring of the equation w/o parens
# @return nil
def parse_eq_emdas(group)
  # EMDAS - order of operations
  ['\*', '\/', '\+', '\-'].each do |op|
    until group.empty?
      pre_length = group.length
      # do calculations with no parenthesis
      # <Floats> are optional in the string
      group.gsub!(/([\-]?\d+\.?\d*?)(#{op})([\-]?\d+\.?\d*?)/) do |x|
        one, two, three = $1, $2, $3
        ans = one.to_f.send(two, three.to_f)
        # puts "EMDAS: #{x}: #{ans}"
        ans
      end
      break if pre_length == group.length
    end
  end
end

# parses out the functions and runs them
def parse_eq_functions(str)
  func_regex = /(\w+)\(([\-]?\d+\.?\d*?)([\*\-])([\-]?\d+\.?\d*?)\)/
  until str.empty?
    pre_length = str.length
    str.gsub(func_regex) do
    end
  end
end

# Displays the equation history from the user
# @return nil
def show_eq_history
  counter = 0
  @history.each { |k, v| puts "#{counter += 1}\) #{k} #{v}" }
end

# History bucket
# Key = <String> equation
# Value = <Integer> answer
@history = {}

# start the application
# display_menu

# Testing Only
str = [
  '(7+3-4)+(23-2)-(4*-5)', # 47
  '((21/3)+3-4)+(42/2)-(4*-5)', # 47
  '((21/3)+-1)-(42/-2)-(4*-5)', # 47
]
str.each do |substr|
  puts "String:\s#{substr}"
  parse_eq_string(substr)
  puts "Answer:\s#{substr}"
end
