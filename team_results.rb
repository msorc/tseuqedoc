class TeamResults
  attr_reader :goals_for, :goals_against, :wins, :draws, :losses
  
  POINTS = { win: 3, draw: 1, loss: 0 }
 
  def initialize
    reset!
  end

  def reset!
    @goals_for = @goals_against = @wins = @draws = @losses = 0    
  end

  def goals_difference
    goals_for - goals_against    
  end

  def points
    wins * POINTS[:win] + draws * POINTS[:draw] + losses * POINTS[:loss]
  end

  def add_score(goals_for, goals_against)
    [goals_for, goals_against].each do |goals|
      raise ArgumentError.new("Goals should be positive integer numbers") if !goals.is_a?(Fixnum) || goals < 0
    end

    @goals_for += goals_for
    @goals_against += goals_against

    if goals_for > goals_against
      @wins   += 1
    elsif goals_for < goals_against
      @losses  += 1
    else
      @draws += 1
    end

    # might be useful
    points
  end
end
