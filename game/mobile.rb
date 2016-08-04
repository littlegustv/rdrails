class Mobile
  attr_reader :id, :room_id, :commands, :user_id, :start, :combat, :combat_buffer, :character_id
  attr_writer :commands, :combat, :combat_buffer
  attr_accessor :behaviors, :affects, :inventory

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
    extend BasicCommands
  end

  def prompt
    "<p>[PROMPT] #{character.stats['hitpoints']}hp</p>"
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
    # that's the command part, below we have the combat, which behaves by the same rules for everyone
  end

  def do_round
    if @combat
      do_hit
      10.times do |i|
        n = rand(10) + i * 10
        if n < stat("attackspeed")
          do_hit
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

  def do_hit
    damage = rand(character.stats["damage"]) + character.stats["damage"]
    @combat.do_damage(damage)
    @combat.combat_buffer += "#{render(@combat)}'s wobbly #{noun} bruises you, dealing #{damage} damage.<br>"
    @combat_buffer += "Your wobbly #{noun} bruises #{@combat.render(self)}, dealing #{damage} damage.<br>"
  end

  def noun
    "entangle"
  end

  def do_damage(n)
    character.stats["hitpoints"] -= n
  end

  def command(cmd)
    @command_queue.push(cmd)
  end

  def is(user)
    @user_id == user.user_id
  end

  def stat(key)
    if character.stats[key]
      character.stats[key] + @behaviors.map{ |k, b| b.stat(key) }.reduce(:+).to_i + @inventory.map { |i| i.stat(key) }.reduce(:+).to_i # fix me: should use equipment, currently using inventory
    end
  end

  def room
    @game.rooms[@room_id]
  end

  def character
    @game.characters[@character_id]
  end

  # the render function gives output to be sent to a player.  this is where we can handle things that affect rendering, like blind
  def render(from, format = :short)
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
      @lag = send(cmd, args)
    else
      @game.emit { |user| "Huh?" if is user }
    end

  end
end