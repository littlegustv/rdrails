module BasicCommands
  def self.extended(mod)
    mod.commands = ["look", "say", "north", "south", "east", "west", "up", "down"]
  end

  def look(args = "")
    @game.send do |u| 
      u.id == @id ? room.render(self, :long) : nil
    end
    return 0
  end

  def say(args)
    string = "'#{args.join(' ')}'"
    @game.send do |u|
      if u.id == @id
        "You say #{string}"
      elsif u.room_id == @room_id
        "#{render(u)} says #{string}"
      end
    end
    return 0
  end

  def north(args)
    move(:north)
  end

  def south(args)
    move(:south)
  end

  def east(args)
    move(:east)
  end

  def west(args)
    move(:west)
  end

  def up(args)
    move(:up)
  end

  def down(args)
    move(:down)
  end

  def move(cmd)
    direction = cmd.to_s.capitalize
    if !room.exits.keys.include?(direction)
      @game.send { |user| "You can't go that way." if user.id == @id }
      return 0
    end
    @game.send do |user|
      if user.id == @id
        "You move #{direction}"
      elsif user.room_id == @room_id
        "#{render(user)} moves #{direction}"
      elsif user.room_id == room.exits[direction]
        "#{render(user)} has arrived."
      end
    end
    @room_id = room.exits[direction]
    look
    puts @command_queue
    return 1
  end

end