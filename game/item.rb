class Item
  attr_reader :name, :description, :stats
  def initialize(name, description, stats)
    @name = name
    @description = description
    @stats = stats
  end

  def stat(key)
    @stats[key] || 0
  end
end