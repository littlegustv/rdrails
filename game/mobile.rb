class Mobile
  attr_reader :id, :room_id, :commands
  attr_writer :commands

  def initialize(id, room_id, character_id, game)
    @id = id
    @command_queue = []
    @lag = 0
    @room_id = room_id
    @character_id = character_id
    @game = game
    @commands = [] #???
    extend BasicCommands
    puts "YEAH #{@commands}"
  end

  def update(dt)
    if @lag > 0
      @lag -= dt
    elsif (c = @command_queue.pop)
      handle(c['message'])
    end
    # that's the command part, below we have the combat, which behaves by the same rules for everyone
  end

  def command(cmd)
    @command_queue.push(cmd)
    puts @command_queue
  end

  def is(id)
    @id == id
  end

  #def send(msg)
  #  @game.send({ |user| user.id == @id }
  #end

  def room
    @game.rooms[@room_id]
  end

  def character
    @game.characters[@character_id]
  end

  def render(from, format = :short)
    case format
    when :short
      character.name
    when :long
      %(
        <h4>#{character.name}</h4>
        <p>#{character.description}</p>
      )
    end
  end

  def handle(cmd)
    # ideally this with inherit from modules, depending on class, etc.
    if cmd.nil?
      return
    end

    args = cmd.split " "
    cmd = args.shift
    if @commands.include? cmd
      @lag = send(cmd, args)
    end
    return

    case cmd
    when nil
    when "look"
      @game.send do |u| 
        u.id == @id ? room.look(self, :long) : nil
      end
      #send(room.look(self, :long))
    when *(["north", "south", "east", "west", "up", "down"] & room.exits.keys.map{ |k| k.downcase })
      # blank
    when /say\s(.+)/
      string = cmd.match(/say\s(.+)/)[1]
      #send "You say '#{string}'"
      @game.send({user: @id, message: "#{@id} says '#{string}'"}) { |user| user.id != @id && user.room_id == @room_id }
    else
      #send("Huh?")
    end
  end
end