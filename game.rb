class Game
  def initialize
    @commands = []
    @players = {}
    @rooms = Room.all
  end

  def speak(channel, msg)
    ActionCable.server.broadcast channel, message: msg, user: ""
  end

  def speaks(players, msg)
    players.each do |p|
      ActionCable.server.broadcast "messages_#{p}", message: msg, user: "" 
    end
  end

  def run
    loop {
      if (cmd = @commands.pop)
        handleCommand(cmd)
      end
      sleep 1.0 / 60
    }
  end

  def handleCommand(c)
    puts "Handling command: #{c.inspect}"
    channel = "clients_#{c['user']}"
    cmd = c["message"]
    #u = players = @players.select { |player| player.id == c['user'] }.first.try
    #u = u.count > 0 ? u.first : nil
    if u = @players[c['user']]
    else
      speak channel, "WHO ARE YOU"
    end

    case cmd
    when "login"
      u = User.find(c['user'])
      @players[u.id] = u
    when u.nil?
      speak(channel, 'WHO ARE YOU?')
    when "look"
      u.speak @rooms.find(u.mobile.room_id).display
    when *["north", "south", "east", "west", "up", "down"]
      @players.select{ |_, p| p != u && p.mobile.room == u.mobile.room }.each{ |_, p| p.speak "#{u.mobile.character.name} leaves #{cmd}."}
      speak(channel, u.mobile.move(cmd.humanize))
      @players.select{ |_, p| p != u && p.mobile.room == u.mobile.room }.each{ |_, p| p.speak "#{u.mobile.character.name} has arrived."}
      @commands.push({"message" => "look", "user" => u.id })
    when "quit"
      @players.delete(u.id)
      # need some way of saving the mobile without it still showing up in game... just an 'active' field? 
      # for now just delete it, you will just 'restart' in beginning room eahc login
      u.mobile.destroy
    when /say\s(.+)/
      string = cmd.match(/say\s(.+)/)[1]
      u.speak "You say '#{string}'"
      @players.each { |_, p| p.speak "#{u.mobile.character.name} says '#{string}'" if p != u && p.mobile.room == u.mobile.room }
    else
      u.speak("Huh?")
    end

  end

  def command(cmd)
    @commands.push(cmd)
  end
end