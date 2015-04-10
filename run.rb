$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")
require 'minitest/autorun'
require 'league_table.rb'

describe TeamResults do
  it "new must have empty points" do
    team_results.points.must_equal 0
  end

  it "new must have empty goals difference" do
    team_results.goals_difference.must_equal 0
  end

  let(:team_results) { TeamResults.new }

  it "must reset results" do
    team_results.add_score(3,0)
    team_results.points.must_equal 3
    team_results.reset!
    team_results.points.must_equal 0
  end

  it "must calculate points correctly" do
    team_results.add_score(1,1)

    team_results.points.must_equal 1
    team_results.draws.must_equal 1

    team_results.add_score(2,1)
    team_results.points.must_equal 4
    team_results.wins.must_equal 1

    team_results.add_score(0,2)
    team_results.add_score(0,2)
    team_results.points.must_equal 4
    team_results.losses.must_equal 2
  end

  it "must calculate goal difference correctly" do
    team_results.add_score(1,4)
    team_results.add_score(3,3)
    team_results.add_score(4,2)
    team_results.add_score(0,5)
    team_results.goals_difference.must_equal -6
    team_results.goals_for.must_equal 8
    team_results.goals_against.must_equal 14
  end

  it "must accept only non negative integers for goals" do
    -> { team_results.add_score(-1,4) }.must_raise ArgumentError
    -> { team_results.add_score(1,-4) }.must_raise ArgumentError
    -> { team_results.add_score('3',4) }.must_raise ArgumentError
    -> { team_results.add_score(1,'4') }.must_raise ArgumentError
  end
end

describe Matches do
  it "notifies league table" do
    league_table = MiniTest::Mock.new
    league_table.expect(:add_score, nil, ["score123"])
    matches = Matches.new(league_table)
    matches.push "score123"
    matches.must_equal ["score123"]
  end
end

describe LeagueTable do
  let(:league_table) { LeagueTable.new }

  it "doesn't accept wrong format score" do
    -> { league_table.matches.push("Man Utd 0 Liverpool") }.must_raise ArgumentError
    -> { league_table.matches.push("2 - 2") }.must_raise ArgumentError
    -> { league_table.matches.push("  2 - 2    CSKA") }.must_raise ArgumentError
    -> { league_table.matches.push("23 doke - 2 888 - 2") }.must_raise ArgumentError
    league_table.matches.must_be :empty?
  end
  
  it "passes base sample" do
    league_table.matches.push("Man Utd 3 - 0 Liverpool")

    league_table.get_goals_for("Man Utd").must_equal 3
    league_table.get_points("Man Utd").must_equal 3
    league_table.get_points("Liverpool").must_equal 0
    league_table.get_goal_difference("Liverpool").must_equal -3

    league_table.matches.push("Liverpool 1 - 1 Man Utd")

    league_table.get_goals_for("Man Utd").must_equal 4
    league_table.get_points("Man Utd").must_equal 4
    league_table.get_points("Liverpool").must_equal 1
    league_table.get_goals_against("Man Utd").must_equal 1

    league_table.get_points("Tottenham").must_equal 0
  end
end
