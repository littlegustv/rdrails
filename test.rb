user = nil

while user.nil?
  puts "What is your Character name?"
  Character.all.each do |character|
    puts "This one? --> #{character.name}"
  end
  attempt = gets.chomp
  if Character.where(name: attempt).count > 0
    user = Character.where(name: attempt).first
    puts "You have chosen: #{user.name}"
  end
end

@steps_taken = 0
while true
  puts "You have taken #{@steps_taken}"
  steps_to_take = gets.chomp
  @steps_taken += steps_to_take
  if @steps_taken > 100
    user.update(name: "#{user.name} - fleet of foot")
  end
end