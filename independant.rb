require 'redis'
require 'connection_pool'
require 'json'
require 'thread'
require './room.rb'
require './character.rb'
require './user.rb'
require './game.rb'

REDIS = ConnectionPool.new(size: 10) { Redis.new }
$game = Game.new(REDIS)

puts 'started'

Thread.new do
  REDIS.with do |redis|
    redis.subscribe 'server' do |on|
      
      on.message do |channel, msg|
        data = JSON.parse(msg)
        if data['message'] == 'login'
          $game.login data['user']
        else
          if (u = $game.user(data['user']))
            u.command(data)
          else
            u = $game.login data['user']
            u.command(data)
          end
        end
      end

    end
  end
end

start_t = Time.now
loop {
  next_t = Time.now
  dt = next_t - start_t
  start_t = next_t
  $game.update(dt)
  sleep 1.0 / 10
}


puts "end"