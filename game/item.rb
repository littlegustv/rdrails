class Item
  attr_reader :name, :description, :stats, :slot
  def initialize(name, description, stats, slot)
    @name = name
    @description = description
    @stats = stats
    @slot = slot
  end

  def stat(key)
    @stats[key] || 0
  end

  def hasBehavior(name)
  	false
  end

  def render(from, format = :short)
  	if format == :short
	  	@name
	  else
	  	%(
	      <div class='item'>
	      <h4>#{@name}</h4>
	      <p>#{@description}</p>
	      <ul>
	      	#{@stats.map { |k, v| "<li><b>" + k + "</b> " + v.to_s + "</li>" }.join("") }
	      </ul>
	      </div>
	    )
	  end
  end
end