SQLITEPATH = "/home/hellerb/Projects/rdrails/db/development.sqlite3"

module SQLITE

  require 'sqlite3'

  def initDB
    begin
      @db = SQLite3::Database.new SQLITEPATH
    rescue SQLite3::CantOpenException
      puts "************************************** ALERT! ************************************"
      puts "Cannot open Database File.  Make sure you have set the correct location in db.rb"
      puts "Enter the complete path to the SQLITE db file, found in your db/ directory of your"
      puts "rails project."
      puts "**********************************************************************************"
    end
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

      @rooms[id] = Room.new(id, row[1], row[2], room_exits, self)
    end
    puts @roomss
  end

  def loadMobiles
    rows = @db.execute "select id, room_id, character_id from mobiles where user_id is null"
    @mobiles = []
    rows.each do |row|
      m = Mobile.new(row[0], row[1], row[2], self)
      @mobiles.push(m)
      loadInventory(m)
    end
  end

  def loadInventory(m)
    items = @db.execute "select item_id from inventory_items where character_id = ?", m.character_id
    puts items, @items
    items.each do |item|
      #puts "here", item[0], @items[item[0]]
      if @items.key?(item[0])
        puts @items[item[0]].name
        m.addItem(@items[item[0]].clone)
      end
    end
  end

  def loadCharacters
    @characters = {}
    rows = @db.execute "select id, name, description, stat_id from characters"
    rows.each do |row|
      stat = @db.execute "select attackspeed, damagereduction, hitpoints, manapoints, damage from stats where id = ?", row[3]
      stat = Hash[['attackspeed', 'damagereduction', 'hitpoints', 'manapoints', 'damage'].zip(stat[0])]
      @characters[row[0]] = Character.new(row[1], row[2], stat)
    end
  end

  def loadItems
    @items = {}
    rows = @db.execute "select id, name, description, stat_id from items"
    rows.each do |row|
      stat = @db.execute "select attackspeed, damagereduction, hitpoints, manapoints, damage from stats where id = ?", row[3]
      stat = Hash[['attackspeed', 'damagereduction', 'hitpoints', 'manapoints', 'damage'].zip(stat[0])]
      @items[row[0]] = Item.new(row[1], row[2], stat)
    end
  end

  def loadPlayerMobileData(user_id)
    user_active = @db.execute "select active_id from users where id = ?", user_id

    rows = @db.execute "select id, room_id, character_id from mobiles where id = ?", user_active[0]
    if rows.count > 0
      rows[0]
    else
      puts "didn't find anyone, sorry"
      nil
    end
  end

end