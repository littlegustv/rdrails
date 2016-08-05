require './db.rb'

class Game
  
  attr_reader :rooms, :characters, :mobiles, :users
  attr_writer :mobiles

  include SQLITE

  def initialize(redis)
    @clock = {analog: 0, digital: 0}
    @users = []
    @mobiles = []
    @REDIS = redis
    initDB
    loadItems
    loadRooms
    loadCharacters
    loadMobiles
  end

  def emit
    @users.each do |user|
      if (msg = yield(user))
        REDIS.with do |redis|
          redis.publish "clients_#{user.user_id}", {user: user.user_id, message: msg + user.prompt}.to_json
          #redis.publish "clients_#{user.user_id}", {user: user.user_id, message: user.prompt}.to_json
        end
      end
    end
  end

  def update(dt)
    @clock[:analog] += dt
    if @clock[:digital] < @clock[:analog].floor
      @clock[:digital] = @clock[:analog].floor
      if @clock[:digital] % 1 == 0
        do_round        
      end

      if @clock[:digital] % 10 == 0
        do_repop
      end
    end

    @mobiles.each do |mobile|
      mobile.update(dt)
    end

  end

  def removeMobile(mobile)
    @mobiles.delete(mobile)
  end

  def do_repop
    emit do |user|
      "Repop"
    end
    loadMobiles
  end

  def do_round
    @users.each do |user|
      user.combat_buffer = ""
    end
    @mobiles.each do |mobile|
      mobile.do_round()
    end
    emit do |user|
      if user.combat_buffer.length > 0
        user.combat_buffer + "#{user.combat.render_condition(self)}<br>"
      end
    end
  end

  def login(id)
    if !user(id)
      m_info = loadPlayerMobileData(id)
      u = Mobile.new(m_info[0], m_info[1], m_info[2], $game, id)
      loadInventory(u)
      @users.push(u)
      @mobiles.push(u)
    else
      u = user(id)
    end
    return u
  end

  def logout(id)
    u = user(id)
    puts @mobiles.delete(@users.delete(u))
  end

  def user(id)
    if (u = @users.select { |user| user.user_id == id }).count > 0
      u.first
    end
  end

  def render(from, format = nil)
    "Players: <br>" + @users.map { |user| user.render(from, :short) }.join("<br>")
  end
end