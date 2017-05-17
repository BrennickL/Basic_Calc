# @author Brennick Langston
# @version 1.0.0

# Displays the Main Menu
# @return
def display_menu
  puts "\n\nMain Menu"
  puts "1) Enter Variables"
  puts "2) Enter Search String"
  puts "0) Quit"
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
  case option.to_i
  when 1
    show_variable_menu
  when 2
    show_eq_menu
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
  ans = var1.to_f.send(op,var2.to_f)
  if !ans.nil?
    printf("Calculated Answer:\s%3.3f\n",ans)
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
  answer = parse_eq_string(eq)
  puts "Answer:\s#{eq}"
  display_menu
end

# Parser for equations submitted as strings
# @param eq <String> simple equation
# @return <String> reduced answer
def parse_eq_string(eq)
  eq_regex = /\((\d+)([\+|\-|\*|\/])(\d+)\)/
  # parenthesis (P)
  eq.gsub!(eq_regex) do |g|
    ans = $1.to_i.send($2,$3.to_i)
    ans
  end
  # EMDAS - order of operations
  ops = ['\*', '\/', '\+', '\-']
  ops.each do |op|
    until eq.empty?
      pre_length = eq.length
      eq.gsub!(/(\d+)([#{op}])(\d+)/) do |x|
        ans = $1.to_i.send($2,$3.to_i)
        ans
      end
      break if eq.length == pre_length
    end
  end
  eq
end

# start the application
display_menu
