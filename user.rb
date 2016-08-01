class Mobile
  def initialize(id, room_id, character_id, game)
    @id = id
    @commands = []
    @lag = 0
    @room_id = room_id
    @character_id = character_id
    @game = game
  end

  def update(dt)
    if @lag > 0
      @lag -= dt
    elsif (c = @commands.pop)
      handle(c['message'])
    end
  end

  def command(cmd)
    @commands.push(cmd)
  end

  def is(id)
    @id == id
  end

  def send(msg)
    @game.send("clients_#{@id}", {user: @id, message: msg})
  end

  def room
    $game.rooms[@room_id]
  end

  def handle(cmd)
    puts room.exits.keys
    case cmd
    when nil
    when "look"
      send(room.look(self, :long))
    when *(["north", "south", "east", "west", "up", "down"] & room.exits.keys.map{ |k| k.downcase })
      @room_id = room.exits[cmd.capitalize]
      send("You move #{cmd.capitalize}.")
      @commands.push({user: @id, command: "look"})
    else
      send("Huh?")
    end
  end
end