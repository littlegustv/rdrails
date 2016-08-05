module BasicCommands
  def self.extended(mod)
    mod.commands.push *["look", "north", "south", "east", "west", "up", "down", "who", "quit", "score", "say", "kill", "flee", "rest", "wake", "quicken", "affects", "inventory", "fireball"]
  end

  def cmd_look(args = "")
    @game.emit { |user| room.render(self, :long) if is user } 
    return 0
  end

  def cmd_say(args)
    if args.count <= 0
      emit "Say what?"
      return 0
    end
    string = "'#{args.join(' ')}'"
    @game.emit do |u|
      if u.id == @id
        "<span class='say'>You say #{string}</span>"
      elsif u.room_id == @room_id
        "<span class='say'>#{render(u)} says #{string}</span>"
      end
    end
    return 0
  end

  def cmd_north(args)
    move(:north)
  end

  def cmd_south(args)
    move(:south)
  end

  def cmd_east(args)
    move(:east)
  end

  def cmd_west(args)
    move(:west)
  end

  def cmd_up(args)
    move(:up)
  end

  def cmd_down(args)
    move(:down)
  end

  def move(cmd)
    if @combat
      emit "You are too busy to do that!"
      return 0
    end
    if hasBehavior("Rest")
      emit "Try standing up first."
      return 0
    end
    direction = cmd.to_s.capitalize
    if !room.exits.keys.include?(direction)
      @game.emit { |user| "You can't go that way." if is user }
      return 0
    end
    @game.emit do |user|
      if user.id == @id
        "You move #{direction}"
      elsif user.room_id == @room_id
        "#{render(user)} moves #{direction}"
      elsif user.room_id == room.exits[direction]
        "#{render(user)} has arrived."
      end
    end
    removeBehavior("Hide")
    @room_id = room.exits[direction]
    cmd_look
    puts @command_queue
    return 0.5
  end

  def cmd_who(args)
    @game.emit { |user| @game.render(self) if is user }
    return 0
  end

  def cmd_quit(args)
    @game.emit do |user| 
      if is user
        "You have quit the game."
      elsif @room_id == user.room_id
        "#{render(user)} has quit the game." 
      end
    end
    @game.logout(@user_id)
    return 0
  end

  def cmd_score(args)
    @game.emit { |user| "<h3>#{character.name}</h3>" + character.stats.map { |k, v| "<b>#{k}</b> - #{v} [#{stat(k)}]"}.join("<br>") if is user }
    return 0
  end

  def cmd_inventory(args)
    emit "<h3>Inventory</h3>" + @inventory.map { |item| "#{item.name}"}.join("<br>") + "<br><br>"
    return 0
  end

  def cmd_kill(args)
    if args.count <= 0
      @game.emit { |user| "Kill whom?" if is user }
      return 0
    else
      target = target_mobile(args)
      if !target
        emit "You can't find them."
        return 0
      elsif start_combat(target)
        @game.emit do |user| 
          if is user
            "You attack #{target.render(self)}!"
          elsif target.is user
            "#{self.render(target)} attacks you!"
          end
        end
        return 1
      else
        return 0
      end
    end
  end

  def cmd_flee(args)
    if !@combat
      @game.emit { |user| "You aren't fighting anyone." if is user }
      return 0
    elsif rand(100) < 60
      @game.emit do |user| 
        if is user 
          "You flee from combat!" 
        elsif @combat.is user
          "#{render(@combat)} has fled!"
        end
      end
      end_combat
      # move!
      return 1
    else
      emit "Panic! You could not escape!"
      return 0
    end
  end

  def cmd_rest(args)
    if @combat
      emit "You can't rest while fighting."
    elsif hasBehavior("Rest")
      emit "You are already resting."
    else
      addBehavior(Rest)
    end
    return 0
  end

  def cmd_wake(args)
    if !hasBehavior("Rest")
      emit "You aren't resting"
    else
      removeBehavior("Rest")
    end
    return 0
  end

  def cmd_quicken(args)
    if hasBehavior("Rest")
      emit "Try waking up first!"
      return 0
    else
      addBehavior(Quicken)
      return 0.5
    end
  end

  def cmd_affects(args)
    emit @behaviors.select { |k, b| !b.duration.nil? }.map { |k, b| "#{k}: ... #{b.duration.to_i} >>> #{b.description}" }.join("<br>")
    return 0
  end

  def cmd_fireball(args)
    if args.count <= 0
      emit "You have to target someone!"
      return 0
    end
    target = target_mobile(args)
    if !target
      emit "You don't see them here."
      return 0
    elsif start_combat(target)
      emit "You launch a fireball at #{target.render(self)}"
      target.addBehavior(Fireball)
      return 1
    else
      return 0    
    end
  end

end