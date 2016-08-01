class User
  def initialize(id, game)
    @id = id
    @commands = []
    @lag = 0
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

  def handle(cmd)
    case cmd
    when nil
    when "look"
      send("You look around.")
    else
      send("Huh?")
    end
  end
end