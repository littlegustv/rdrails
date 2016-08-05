module ThiefCommands
  def self.extended(mod)
    mod.commands.push *["backstab", "peer", "peek", "hide", "dirtkick", "rub"]
  end

  def cmd_backstab(args)
    if (target = target_mobile(args))
      if start_combat(target)
        if target.get_percentage < 40
          emit "They are hurt and suspicious, you can't sneak up."
          return 0
        else
          do_hit("backstab", false)
          return 1
        end
      end
    end
    return 0
  end

  def cmd_peer(args)
    if (target = target_exit(args))
      emit "You peer #{target[0]}:<br>" + target[1].render(self)
      return 0.4
    else
      emit "There is no exit in that direction."
      return 0
    end
  end

  def cmd_peek(args)
    if (target = target_mobile(args))
      emit "You get a look at what they're carrying:<br>" + target.inventory.map(&:name).join("<br>")
      return 0.4
    else
      emit "You don't see them here."
      return 0
    end
  end

  def cmd_hide(args)
    if @combat
      emit "You are too busy fighting to do that!"
      return 0
    else
      addBehavior(Hide)
    end
    return 1
  end

  def cmd_dirtkick(args)
    if (target = target_mobile(args))
      if start_combat(target)
        if target.hasBehavior("Dirtkick")
          emit "They are already blinded."
          return 0
        else
          target.addBehavior(Dirtkick)
          return 1
        end
      end
    end
    return 0
  end

  def cmd_rub(args)
    if hasBehavior("Dirtkick")
      removeBehavior("Dirtkick")
      return 1
    else
      emit "Your eyes are fine, thanks."
      return 0
    end
  end

end