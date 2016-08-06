class Mobile
  attr_reader :id, :room_id, :commands, :user_id, :start, :combat, :combat_buffer, :character_id
  attr_writer :commands, :combat, :combat_buffer
  attr_accessor :behaviors, :affects, :inventory, :stats, :equipment

  def initialize(id, room_id, character_id, game, user_id = nil)
    @id = id
    @user_id = user_id
    @command_queue = []
    @lag = 0
    @room_id = room_id
    @character_id = character_id
    @game = game
    @combat = nil
    @commands = [] #???
    @combat_buffer = ""
    @behaviors = {}
    @inventory = []
    @equipment = {}
    @stats = character.stats.clone
    extend BasicCommands
    extend ThiefCommands
  end

  def prompt
    "<p class='prompt'>#{stat('hitpoints').to_i}/#{base('hitpoints')} hp #{stat('manapoints').to_i}/#{base('hitpoints')} mp</p>"
  end

  def equip(slot, item)
    puts "#{slot}, #{item}"
    if item
      puts "Equipping! #{item.name}"
    end
    if !@equipment[slot].nil?
      unequip(slot)
    end
    @equipment[slot] = item
  end

  def unequip(slot)
    if @equipment[slot]
      item = @equipment[slot].clone
      @equipment.delete(slot)
      item
    end
  end

  def addItem(item)
    @inventory.push(item)
  end

  def removeItem(name)
    item = @inventory.select { |item| item.match(/\A#{name}.*/) }.first    
    @inventory.delete(item)
    item
  end

  def addBehavior(behavior)
    b = behavior.new(self)
    @behaviors[behavior.to_s] = b
    b.onStart
  end

  def hasBehavior(keys)
    keys = Array(keys)
    keys.each do |key|
      if @behaviors.key? key
        return true
      end
    end
    return false
  end

  def removeBehavior(key)
    if @behaviors.key? key
      @behaviors[key].onEnd
      @behaviors.delete(key)
    end
  end

  def update(dt)
    if @lag > 0
      @lag -= dt
    elsif (c = @command_queue.pop)
      handle(c['message'])
    end
    @behaviors.each{ |k, b| b.update(dt) }

    if stat("hitpoints") <= 0
      die
    end 
    # that's the command part, below we have the combat, which behaves by the same rules for everyone
  end

  def die
    if @combat
      buffer = ""
      if user_id
        @game.emit do |user|
          "#{character.name} suffers defeat at the hands of #{@combat.character.name}!!"
        end
      else
        #looting from npcs only, at the moment
        @inventory.each do |item|
          #item.render
          buffer += "You get #{item.name} from the corpse of #{render(@combat)}.<br>"
          @combat.addItem item
        end
      end

      buffer += "#{character.name} is DEAD!!<br>"
      @combat.emit buffer
      end_combat
    end
    if @user_id
      @stats = character.stats.clone
      @behaviors = {}
      emit "You have been KILLED!"
      addBehavior(Nervous)
      addBehavior(Rest)
    else
      @game.removeMobile(self)
    end
  end

  def check_combat(mobile)
    if is mobile
      emit "Suicide is a mortal sin."
      return false
    elsif mobile.hasBehavior("Nervous")
      emit "Give them a chance to breath."
      return false
    elsif hasBehavior("Rest")
      emit "Try standing up first."
      return false
    elsif hasBehavior("Nervous")
      emit "You are too nervous to start anything like that."
      return false
    elsif mobile && mobile == @combat
      return true
    elsif @combat
      emit "You are already fighting someone!"
      return false
    else
      return true
    end
  end

  def start_combat(mobile, check=true)
    if !check_combat(mobile) && check
    else
      @combat = mobile
      mobile.combat = self
      removeBehavior("Hide")
      return true
    end
  end

  def end_combat
    @combat.combat = nil
    @combat = nil
  end

  def skill(name)
    # right now all skills have a 75% change of succeeding
    yield rand(100) <= 75
  end

  def do_round
    if @combat
      do_hit(noun)
      10.times do |i|
        n = rand(10) + i * 10
        if n < stat("attackspeed")
          do_hit(noun)
        end
      end

      @behaviors.each do |k, b|
        b.onCombat
      end
    end
  end

  def emit(msg)
    @game.emit { |user| msg if is user }
  end

  def get_percentage
    100 * stat("hitpoints") / character.stats["hitpoints"]
  end

  def render_condition(from)
    percentage = get_percentage

    if percentage == 100
      condition = "#{render(from)} is in excellent condition."
    elsif percentage >= 80
      condition =  "#{render(from)} has some small wounds and bruises."
    elsif percentage >= 60
      condition =  "#{render(from)} has quite a few wounds."
    elsif percentage >= 40
      condition =  "#{render(from)} has some big nasty wounds and scratches."
    elsif percentage >= 20
      condition =  "#{render(from)} is pretty hurt."
    elsif percentage > 0
      condition =  "#{render(from)} is in awful condition."
    else
      condition =  "BUG: #{render(from)} is mortally wounded and should be dead."
    end
    condition
  end

  def do_hit(noun, buffered=true)
    damage = rand(@stats["damage"]) + @stats["damage"]
    @combat.do_damage(damage)
    if buffered
      @combat.combat_buffer += "#{render(@combat)}'s wobbly #{noun} bruises you, dealing #{damage} damage.<br>"
      @combat_buffer += "Your wobbly #{noun} bruises #{@combat.render(self)}, dealing #{damage} damage.<br>"
    else
      @combat.emit "#{render(@combat)}'s wobbly #{noun} bruises you, dealing #{damage} damage.<br>"
      emit "Your wobbly #{noun} bruises #{@combat.render(self)}, dealing #{damage} damage.<br>"
    end
  end

  def noun
    "entangle"
  end

  def do_damage(n)
    @stats["hitpoints"] -= n
  end

  def command(cmd)
    @command_queue.push(cmd)
  end

  def is(user)
    if @user_id
      @user_id == user.user_id
    else
      @id == user.id
    end
  end

  def stat(key)
    if @stats[key]
      @stats[key] + @behaviors.map{ |k, b| b.stat(key) }.reduce(:+).to_i + @equipment.map { |_, i| i ? i.stat(key) : 0 }.reduce(:+).to_i # fix me: should use equipment, currently using inventory
    end
  end

  def base(key)
    character.stats[key]
  end

  def room
    @game.rooms[@room_id]
  end

  def character
    @game.characters[@character_id]
  end

  def target_mobile(args)
    targets = @game.mobiles.select do |mobile| 
      mobile.room_id == @room_id && mobile.render(self).downcase.match(/\A#{args[0]}/) && can_target(mobile)
    end
    target = targets.first
  end

  def target_item(args, list)
    list.select { |i| i && i.name.downcase.match(/\A#{args[0]}/) && can_target(i) }.first
  end

  def can_target(mobile)
    # if blind, cannot target at all
    if hasBehavior(["Blind", "Dirtkick", "Smokebomb"])
      return false
    elsif mobile.hasBehavior(["Hide"])
      return false
    elsif mobile.hasBehavior(["Invisible"]) && !hasBehavior(["DetectInvisible"])
      return false
    end
    return true
  end

  def target_exit(args)
    exit = room.exits.select { |direction, room_id| direction.downcase.match(/\A#{args[0]}/)}.first
    if exit
      puts exit
      return [exit[0], @game.rooms[exit[1]]]
    else
      return false
    end
  end

  # the render function gives output to be sent to a player.  this is where we can handle things that affect rendering, like blind
  def render(from, format = :short)
    # if hidden, shouldn't even try to hide?
    if hasBehavior("Hide") || from.hasBehavior(["Blind", "Dirtkick", "Smokebomb"])
      return "Someone"
    end

    case format
    when :short
      character.name
    when :long
      %(
        <h4>#{character.name}</h4>
        <p>#{character.description}</p>
      )
    else
      character.name
    end
  end

  def handle(cmd)
    # ideally this with inherit from modules, depending on class, etc.
    if cmd.nil?
      return
    end

    args = cmd.split " "
    cmd = args.shift
    cmd = @commands.select { |command| command.match(/\A#{cmd}.*\z/) }
    if cmd.count <= 0
      @game.emit { |user| "Huh?" if is user }
    elsif (cmd = cmd.first)
      @lag = send("cmd_#{cmd}", args)
    else
      @game.emit { |user| "Huh?" if is user }
    end

  end
end