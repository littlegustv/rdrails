require './db.rb'

class Game
  
  attr_reader :rooms, :characters

  include SQLITE

  def initialize(redis)
    @users = []
    @REDIS = redis
    initDB
    loadRooms
    loadCharacters
  end

  def send
    @users.each do |user|
      if (msg = yield(user))
        REDIS.with do |redis|
          redis.publish "clients_#{user.id}", {user: user.id, message: msg}.to_json
        end
      end
    end
=begin
    Array(channels).each do |channel|
      puts "sending #{channel}, #{message.to_json}"      
      REDIS.with do |redis|
        redis.publish channel, message.to_json
      end
      puts 'sent'
    end
=end
  end

  def update(dt)
    @users.each do |user|
      user.update(dt)
    end
  end

  def login(id)
    if !user(id)
      m_info = loadPlayerMobileData(id)
      u = Mobile.new(id, m_info[0], m_info[1], $game)
      #u = User.new(id, $game)
      @users.push(u)
    else
      u = user(id)
    end
    return u
  end

  def user(id)
    if (u = @users.select { |user| user.is(id) }).count > 0
      u.first
    end
  end
end