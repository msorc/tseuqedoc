class Matches < Array
  def initialize(league_table)
    @league_table = league_table
  end

  def push(value)
    @league_table.add_score(value)
    super
  end
end
