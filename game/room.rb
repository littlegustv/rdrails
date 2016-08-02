class Room
  attr_reader :name, :description, :exits

  def initialize(name, description, exits)
    @name = name
    @description = description
    @exits = exits
  end

  def render(from, format)
    %(
      <h4>#{name}</h4>
      <p>#{description}</p>
      <ul class='list-inline'><li>[#{exits.map{|k,v| k}.join("]</li><li>[")}]</li></ul>
    )
  end
end