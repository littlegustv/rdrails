class Behavior
  attr_accessor :mobile, :duration, :stats

  def initialize(mobile)
    @mobile = mobile
    @stats = {}
  end

  def start
    @duration = 0
    onStart
  end

  def update(dt)
    if !@duration.nil?
      @duration -= dt  
      if @duration < 0
        @mobile.removeBehavior(self.class.to_s)
      end
    end
    onUpdate(dt)
  end

  def onStart
  end

  def onUpdate(dt)
  end

  def onCombat
  end

  def onRender
  end

  def onEnd
  end

  def description
    "N/A"
  end

  def stat(key)
    @stats[key] || 0
  end
end

class Rest < Behavior
  def onStart
    @duration = nil
    @mobile.emit "You begin to rest."
  end

  def onUpdate(dt)
    @mobile.stats["hitpoints"] += 2 * dt
  end

  def onEnd
    @mobile.emit "You wake and stand up."
  end
end

class Quicken < Behavior
  def onStart
    @duration = 20
    @stats["attackspeed"] = 10
    @mobile.emit "Things seem faster."
  end

  def onUpdate(dt)
    @mobile.stats["hitpoints"] -= 1 * dt
  end

  def onCombat
#    if rand(100) < 50
#      @mobile.do_hit
#    end
  end

  def onEnd
    @mobile.emit "Not so fast!"
  end

end

class Nervous < Behavior
  def onStart
    @duration = 20
  end

  def onEnd
    @mobile.emit "You can now fight again."
  end
end

class Fireball < Behavior
  def onStart
    @duration = 5
    @mobile.emit "You are hit by a fireball!"
    @mobile.do_damage(20)
  end

  def onCombat
    @mobile.emit "It burns!"
    $game.emit do |user|
      if user.room_id == @mobile.room_id && !user.is(@mobile)
        "#{@mobile.render(user)} is burned by the flames." 
      end
    end
    @mobile.do_damage(4)
  end
end