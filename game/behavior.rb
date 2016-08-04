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
    @mobile.character.stats["hitpoints"] += 2 * dt
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
    @mobile.character.stats["hitpoints"] -= 1 * dt
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