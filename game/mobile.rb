class Mobile
  attr_reader :id, :room_id, :commands, :user_id, :start, :combat
  attr_writer :commands, :combat

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
    extend BasicCommands
  end

  def update(dt)

    if @lag > 0
      @lag -= dt
    elsif (c = @command_queue.pop)
      handle(c['message'])
    end
    # that's the command part, below we have the combat, which behaves by the same rules for everyone
  end

  def do_round
    if @combat
      @game.emit { |user| "You are in combat with #{@combat.render(self)}!" if is user }
    end
  end

  def command(cmd)
    @command_queue.push(cmd)
  end

  def is(user)
    @user_id == user.user_id
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