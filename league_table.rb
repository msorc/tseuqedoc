require 'team_results'
require 'matches'

class LeagueTable
  attr_reader :matches
  SCORE_REGEXP = /(\S.*\S) (\d+) - (\d+) (\S.*\S)/

  def initialize
    @teams = Hash.new { |h,k| h[k] = TeamResults.new }
    @matches = Matches.new(self)
  end

  def add_score(score)
    if score.is_a?(String) && (m = score.match(SCORE_REGEXP)) && m 
      home_team, home_score, away_score, away_team = m.captures
    else
      raise ArgumentError.new("Score should be string in the format 'Team Name NN - YY Team2 Name'")
    end

    home_score = home_score.to_i
    away_score = away_score.to_i

    @teams[home_team].add_score(home_score, away_score)
    @teams[away_team].add_score(away_score, home_score)
  end

  # Returns the no. of points a team has, 0 by default
  def get_points(team_name)
    @teams[team_name].points
  end

  # Returns the no. of goals a team has scored, 0 by default
  def get_goals_for(team_name)
    @teams[team_name].goals_for
  end

  # Returns the no. of goals a team has conceeded (had scored against them), 0 by default
  def get_goals_against(team_name)
    @teams[team_name].goals_against
  end

  # Return the no. of goals a team has scored minus the no. of goals a team has conceeded, 0 by default
  def get_goal_difference(team_name)
    @teams[team_name].goals_difference
  end

  # Return the no. of wins a team has, 0 by default
  def get_wins(team_name)
    @teams[team_name].wins
  end

  # Return the no. of draws a team has, 0 by default
  def get_draws(team_name)
    @teams[team_name].draws
  end

 # Return the no. of losses a team has, 0 by default
  def get_losses(team_name)
    @teams[team_name].losses
  end
end
