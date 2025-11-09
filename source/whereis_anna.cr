def get_statistics(a1, a2, b1, b2, c1, c2)
  a = [ a1, a2 ]
  b = [ b1, b2 ]
  c = [ c1, c2 ]

  matrix = [[
    [[a[0], a[0]], [a[0], b[0]], [a[0], c[0]]],
    [[b[0], a[0]], [b[0], b[0]], [b[0], c[0]]],
    [[c[0], a[0]], [c[0], b[0]], [c[0], c[0]]],
  ], [
    [[a[1], a[1]], [a[1], b[1]], [a[1], c[1]]],
    [[b[1], a[1]], [b[1], b[1]], [b[1], c[1]]],
    [[c[1], a[1]], [c[1], b[1]], [c[1], c[1]]],
  ], [
    [[0.50, 0.50], [0.50, 0.50], [0.50, 0.50]],
    [[0.50, 0.50], [0.50, 0.50], [0.50, 0.50]],
    [[0.50, 0.50], [0.50, 0.50], [0.50, 0.50]],
  ]]

  label_type       = matrix[0]
  definition_type  = matrix[1]
  probability_type = matrix[2]
  
  row_probability = 0.33
  col_probability = 0.33
  
  graph_selection = row_probability * col_probability

  row_options = [0, 1, 2]
  col_options = [0, 1, 2]
  arr_options = [0, 1]

  cur_row = row_options.sample
  cur_col = col_options.sample
  cur_arr = arr_options.sample
  
  current_label       = label_type[cur_row][cur_col][cur_arr]
  current_definition  = definition_type[cur_row][cur_col][cur_arr]
  
  base_probability = probability_type[cur_row][cur_col][cur_arr].to_i
  
  current_probability = base_probability + graph_selection
  
  current_probability = current_probability + current_probability
  current_information = "#{current_label} #{current_definition}"
  
  puts "I'm confident it is not [ #{current_label} #{current_definition} ] as it has only #{current_probability} probability."
  
  File.write("data/statistics/probability/current_probability.txt", "#{current_probability}")
  File.write("data/statistics/label/current_information.txt",       current_information)
  
  #File.open("data/statistics/probability/current_probability.txt", "w") { |f|
  #  f.puts current_probability
  #}
  
  #File.open("data/statistics/label/current_information.txt", "w") { |f|
  #  f.puts current_information
  #}
end

def reasses
  current_probability = File.read("data/statistics/probability/current_probability.txt").to_f
  current_information = File.read("data/statistics/label/current_information.txt")

  if current_probability > 0.999999999999999999
    current_probability = 0.9 / current_probability
  end
  
  case current_probability
  when 0.003921569000000000..0.287225000000000000
    puts "I'm confident it is not [ #{current_information} ] as its only #{current_probability}."
  when 0.287225000000000001..0.522225000000000000
    puts "I'm less unconfident it is not [ #{current_information} ] as its only #{current_probability}."
  when 0.522225000000000001..0.756112500000000000
    puts "I'm almost sure it is [ #{current_information} ] because it has #{current_probability}."
  when 0.756112500000000001..0.999999999999999999
    puts "I'm sure it is [ #{current_information} ] after all it has #{current_probability}."

  else
    puts "The probability is either to low or to large, so I can't determine exactly."
  end
  
  current_probability    = current_probability + current_probability
  
  File.write("data/statistics/probability/current_probability.txt", "#{current_probability}")
  File.write("data/statistics/label/current_information.txt",       current_information)
end

def dynamic_reward_allocation
  l1_reasses = "level one reasses"
  l2_reasses = "level two reasses"
  l3_reasses = "level tre reasses"
  l4_reasses = "level fro reasses"

  reward_model = [
    [[l1_reasses, l1_reasses, l1_reasses, l1_reasses],
     [l1_reasses, l1_reasses, l1_reasses, l2_reasses],
     [l1_reasses, l1_reasses, l1_reasses, l3_reasses],
     [l1_reasses, l1_reasses, l1_reasses, l4_reasses]],
   
    [[l2_reasses, l2_reasses, l2_reasses, l1_reasses],
     [l2_reasses, l2_reasses, l2_reasses, l2_reasses],
     [l2_reasses, l2_reasses, l2_reasses, l3_reasses],
     [l2_reasses, l2_reasses, l2_reasses, l4_reasses]],
   
    [[l3_reasses, l3_reasses, l3_reasses, l1_reasses],
     [l3_reasses, l3_reasses, l3_reasses, l2_reasses],
     [l3_reasses, l3_reasses, l3_reasses, l3_reasses],
     [l3_reasses, l3_reasses, l3_reasses, l4_reasses]],
   
    [[l4_reasses, l4_reasses, l4_reasses, l1_reasses],
     [l4_reasses, l4_reasses, l4_reasses, l2_reasses],
     [l4_reasses, l4_reasses, l4_reasses, l3_reasses],
     [l4_reasses, l4_reasses, l4_reasses, l4_reasses]],
  ]

  row_options = [0, 1, 2, 3]
  col_options = [0, 1, 2, 3]
  arr_options = [0, 1, 2, 3]

  cur_row = row_options.sample
  cur_col = col_options.sample
  cur_arr = arr_options.sample

  current_reward_structure = reward_model[cur_row][cur_col][cur_arr]

  if    current_reward_structure == l1_reasses; reasses
  elsif current_reward_structure == l2_reasses; 2.times do reasses end
  elsif current_reward_structure == l3_reasses; 3.times do reasses end
  elsif current_reward_structure == l4_reasses; 4.times do reasses end
  else
    reasses
  end
end

def correct_recollection(a, b, c)
  print "You remembered #{a} was in #{c}, but instead #{b} is present in #{c}."
  puts " Consider checking with other documents or photos to verify."

  2.times do
    get_statistics(:remembered_a,     a,
                   :misremembered_b,  b,
                   :representation_c, c)
   
    dynamic_reward_allocation
    #reasses
    #reasses
    #reasses
    #reasses
  end
end

## Analyze Identity
def analyze_nom(a, b, c)  
  2.times do
    get_statistics(:first_name,  "Cette nom est #{a}.",
                   :second_name, "Mais cette nom est #{b}.",
                   :third_name,  "Sinon les noms sont ne #{a} or #{b}. Mais es #{c}.")
                 
                   dynamic_reward_allocation         
  end
end

def analyze_ninom(a, b, c)  
  2.times do
    get_statistics(:first_name,  "Cette ninom est #{a}.",
                   :second_name, "Mais cette ninom est #{b}.",
                   :third_name,  "Sinon les ninomesu sont ne #{a} or #{b}. Mais es #{c}.")
                 
                   dynamic_reward_allocation         
  end
end

def analyze_buttai(a, b, c)
  2.times do
    get_statistics(:first_object,  "C'est un/une #{a}.",
                   :second_object, "Mais c'est un/une #{b}.",
                   :third_object,  "Sinon c'est ne #{a} ou #{b} mais #{c}.")
                 
                   dynamic_reward_allocation         
  end
end

def analyze_nibuttai(a, b, c)  
  2.times do
    get_statistics(:first_object,  "N'est un/une #{a}.",
                   :second_object, "Mais n'est un/une #{b}.",
                   :third_object,  "Sinon n'est ne #{a} ou #{b} mais #{c}.")
                 
                   dynamic_reward_allocation         
  end
end

def analyze_temps(a, b, c)
  2.times do
    get_statistics(:first_time,  "Cette temp est #{c}.",
                   :second_time, "Mais cette temp est #{b}.",
                   :third_time,  "Sinon c'est ne #{a} ou #{b} mais le temp #{c}.")
                 
                   dynamic_reward_allocation         
  end
end

def analyze_netemps(a, b, c)  
  2.times do
    get_statistics(:first_time,  "Cette netemps est #{c}.",
                   :second_time, "Mais cette netemps est #{b}.",
                   :third_time,  "Sinon c'est ne #{a} ou #{b} mais le netemps #{c}.")
                 
                   dynamic_reward_allocation         
  end
end

def analyze_fukin(a, b, c)  
  2.times do
    get_statistics(:first_vicinity,  "Cette vicinity est #{c}.",
                   :second_vicinity, "Mais cette vicinity est #{b}.",
                   :third_vicinity,  "Sinon c'est ne #{a} ou #{b} mais le vicinity #{c}.")
                 
                   dynamic_reward_allocation         
  end
end

def analyze_nifukin(a, b, c)  
  2.times do
    get_statistics(:first_vicinity,  "Cette vicinity est #{c}.",
                   :second_vicinity, "Mais cette vicinity est #{b}.",
                   :third_vicinity,  "Sinon c'est ne #{a} ou #{b} mais le vicinity #{c}.")
                 
                   dynamic_reward_allocation         
  end
end

puts "Preferred Name"
puts "French Identity Preference"
analyze_nom("Anna", "Takashi", "Marie")
analyze_ninom("Takashi", "Anna", "Anna")

puts "Japanese Identity Preference"
analyze_ninom("Anna", "Takashi", "Marie")
analyze_nom("Takashi", "Anna", "Anna")

puts "Preferred Posessions"
puts "French Identity Preference"
analyze_buttai("sabots", "birkenstocks", "crocs")
analyze_nibuttai("birkenstocks", "sabots", "crocs")

puts "Japanese Identity Preference"
analyze_buttai("geta", "birkenstocks", "crocs")
analyze_nibuttai("birkenstocks", "geta", "crocs")

puts "Preferred Times"
puts "French Identity Preference"
analyze_temps("6:00 A.M.", "12:00 P.M.", "6:00 P.M.")
analyze_netemps("12:00 P.M.", "6:00 P.M.", "6:00 P.M.")

puts "Japanese Identity Preference"
analyze_temps("12:00 P.M.", "6:00 P.M.", "6:00 P.M.")
analyze_netemps("6:00 A.M.", "12:00 P.M.", "6:00 P.M.")

puts "Preferred Vicinity"
puts "French Identity Preference"
analyze_fukin("prefer being in a car", "prefer being in a pagoda", "prefer being in a house")
analyze_nifukin("prefer being in a pagoda", "prefer being in a car", "prefer being in a house")

puts "Japanese Identity Preference"
analyze_nifukin("prefer being in a car", "prefer being in a pagoda", "prefer being in a house")
analyze_fukin("prefer being in a pagoda", "prefer being in a car", "prefer being in a house")
