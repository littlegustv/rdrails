module SQLITE

  require 'sqlite3'

  def initDB
    @db = SQLite3::Database.new "./db/development.sqlite3"
  end

  def loadRooms
    @rooms = {}
    rows = @db.execute "select id, name, description from rooms"
    rows.each do |row|
      id = row[0]
      exits = @db.execute "select direction, destination_id from exits where room_id = ?", id
      room_exits = {}
      exits.each do |exit|
        room_exits[exit[0]] = exit[1]
      end
      @rooms[id] = Room.new(row[1], row[2], room_exits)
    end
    puts @roomss
  end

  def loadCharacters
    @characters = {}
    rows = @db.execute "select id, name, description from characters"
    rows.each do |row|
      @characters[row[0]] = Character.new(row[1], row[2])
    end
  end

  def loadPlayerMobileData(user_id)
    rows = @db.execute "select room_id, character_id from mobiles where user_id = ?", user_id
    if rows.count > 0
      rows[0]
    else
      puts "didn't find anyone, sorry"
      nil
    end
  end

end