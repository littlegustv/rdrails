class Game
  
  def initialize(redis)
    @users = []
    @REDIS = redis
  end

  def send(channels, message)
    Array(channels).each do |channel|
      puts "sending #{channel}, #{message.to_json}"      
      REDIS.with do |redis|
        redis.publish channel, message.to_json
      end
      puts 'sent'
    end
  end

  def update(dt)
    @users.each do |user|
      user.update(dt)
    end
  end

  def login(id)
    if !user(id)
      @users.push(User.new(id, $game))
    else
      puts "Already logged in"
    end
  end

  def user(id)
    if (u = @users.select { |user| user.is(id) }).count > 0
      u.first
    end
  end

end