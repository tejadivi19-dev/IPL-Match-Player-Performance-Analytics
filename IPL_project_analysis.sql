 
USE ipl_analytics;
#Which team has won the most IPL matches?
SELECT winner,
       COUNT(*) AS wins
FROM matches
GROUP BY winner
ORDER BY wins DESC;
#Total number of matches played
SELECT COUNT(*) AS total_matches
FROM matches;
#Total number of deliveries
SELECT COUNT(*) AS total_deliveries
FROM deliveries;
#List all IPL seasons
select  distinct season from matches
order by season;
#Number of matches played each season
SELECT season,
COUNT(*) AS matches
FROM matches
GROUP BY season
ORDER BY season;
#Number of matches played in each city
SELECT city,
COUNT(*) AS matches
FROM matches
GROUP BY city
ORDER BY matches DESC;
#top 10 venues by matches hosted
select venue, count(*)  as matchs from matches
group by venue
order by matchs desc

#Total wins by each team
SELECT winner,
COUNT(*) AS wins
FROM matches
GROUP BY winner
ORDER BY wins DESC;

#Toss wins by each team
SELECT toss_winner,
COUNT(*) AS toss_wins
FROM matches
GROUP BY toss_winner
ORDER BY toss_wins DESC;
#Number of matches won by batting first and chasing
SELECT
    CASE
        WHEN result = 'runs' THEN 'Batting First'
        WHEN result = 'wickets' THEN 'Chasing'
        ELSE 'Other'
    END AS Winning_Method,
    COUNT(*) AS Matches
FROM matches
GROUP BY Winning_Method;
#Toss decision frequency
SELECT toss_decision,
COUNT(*) AS count
FROM matches
GROUP BY toss_decision;
#Top 10 run scorers
SELECT batter,
SUM(batsman_runs) AS total_runs
FROM deliveries
GROUP BY batter
ORDER BY total_runs DESC
LIMIT 10;
#Top 10 wicket takers
SELECT bowler,
SUM(is_wicket) AS wickets
FROM deliveries
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;
#Batters with the most sixes
SELECT batter,
COUNT(*) AS sixes
FROM deliveries
WHERE batsman_runs = 6
GROUP BY batter
ORDER BY sixes DESC
LIMIT 10;
#Batters with the most fours
SELECT batter,
COUNT(*) AS fours
FROM deliveries
WHERE batsman_runs = 4
GROUP BY batter
ORDER BY fours DESC
LIMIT 10;
#Batters with the most singles
SELECT batter,
COUNT(*) AS singles
FROM deliveries
WHERE batsman_runs = 1
GROUP BY batter
ORDER BY singles DESC
LIMIT 10;

#Batters with the most dot bolls
SELECT batter,
COUNT(*) AS dots
FROM deliveries
WHERE batsman_runs = 0
GROUP BY batter
ORDER BY dots DESC
LIMIT 10;

#Bowlers who bowled the most dot balls
SELECT bowler,
COUNT(*) AS dot_balls
FROM deliveries
WHERE total_runs = 0
GROUP BY bowler
ORDER BY dot_balls DESC
LIMIT 10;
#Total runs scored by each batting team
SELECT batting_team,
SUM(total_runs) AS total_runs
FROM deliveries
GROUP BY batting_team
ORDER BY total_runs DESC;

#Total wickets taken against each batting team
SELECT batting_team,
SUM(is_wicket) AS wickets_lost
FROM deliveries
GROUP BY batting_team
ORDER BY wickets_lost DESC;
#Total runs scored in each match phase
SELECT match_phase,
SUM(total_runs) AS runs
FROM deliveries
GROUP BY match_phase;
#Total wickets in each match phase
SELECT match_phase,
SUM(is_wicket) AS wickets
FROM deliveries
GROUP BY match_phase;
# Top partnerships
SELECT batter,
non_striker,
SUM(total_runs) AS partnership_runs
FROM deliveries
GROUP BY batter, non_striker
ORDER BY partnership_runs DESC
LIMIT 10;
#Teams That Won More Than 100 Matches
SELECT winner,
       COUNT(*) AS wins
FROM matches
GROUP BY winner
HAVING COUNT(*) > 100
ORDER BY wins DESC;

#Players Who Won More Than 5 Player of the Match Awards
SELECT player_of_match,
       COUNT(*) AS awards
FROM matches
GROUP BY player_of_match
HAVING COUNT(*) > 5
ORDER BY awards DESC;

#Team-wise Total Runs (Using JOIN)
SELECT
m.winner,
SUM(d.total_runs) AS Total_Runs
FROM matches m
INNER JOIN deliveries d
ON m.id = d.match_id
GROUP BY m.winner
ORDER BY Total_Runs DESC;

#Match Winner and COUNT Player of the Match IN EACH SEASON
SELECT season,
winner,
COUNT(player_of_match)
FROM matches
group by season,winner
ORDER BY season;

#How many matches did each team win in each season?"
SELECT season,
       winner,
       COUNT(*) AS matches_won
FROM matches
WHERE winner IS NOT NULL
GROUP BY season, winner
ORDER BY season, matches_won DESC;

#Batters With More Than 3000 Runs
SELECT
batter,
SUM(batsman_runs) AS Runs
FROM deliveries
GROUP BY batter
HAVING SUM(batsman_runs) > 3000
ORDER BY Runs DESC;

#Bowlers With More Than 100 Wickets
SELECT
bowler,
SUM(is_wicket) AS Wickets
FROM deliveries
GROUP BY bowler
HAVING SUM(is_wicket) > 100
ORDER BY Wickets DESC;

#Highest Scoring Team
SELECT
batting_team,
SUM(total_runs) AS Runs
FROM deliveries
GROUP BY batting_team
ORDER BY Runs DESC
LIMIT 1;
#Most Economical Bowling Team
SELECT
bowling_team,
ROUND(AVG(total_runs),2) AS Avg_Runs
FROM deliveries
GROUP BY bowling_team
ORDER BY Avg_Runs;

#Seasons With More Than 70 Matches
SELECT
season,
COUNT(*) AS Matches
FROM matches
GROUP BY season
HAVING COUNT(*) > 70;

#Teams That Chose to Bat First
SELECT
toss_winner,
COUNT(*) AS Times_Batted_First
FROM matches
WHERE toss_decision='bat'
GROUP BY toss_winner
ORDER BY Times_Batted_First DESC;

#Teams That Chose to Field First
SELECT
toss_winner,
COUNT(*) AS Times_Fielded_First
FROM matches
WHERE toss_decision='field'
GROUP BY toss_winner
ORDER BY Times_Fielded_First DESC;

#Batters Who Hit More Than 150 Sixes
SELECT
batter,
COUNT(*) AS Sixes
FROM deliveries
WHERE batsman_runs=6
GROUP BY batter
HAVING COUNT(*)>150
ORDER BY Sixes DESC;
#Bowlers With More Than 1000 Dot Balls
SELECT
bowler,
COUNT(*) AS Dot_Balls
FROM deliveries
WHERE total_runs=0
GROUP BY bowler
HAVING COUNT(*)>1000
ORDER BY Dot_Balls DESC;
# Venue-wise Matches
SELECT
venue,
COUNT(*) AS Matches
FROM matches
GROUP BY venue
ORDER BY Matches DESC;
#Average Target Runs
SELECT
ROUND(AVG(target_runs),2) AS Average_Target
FROM matches;

#Rank Batters by Total Runs
SELECT
    batter,
    SUM(batsman_runs) AS total_runs,
    RANK() OVER (ORDER BY SUM(batsman_runs) DESC) AS player_rank
FROM deliveries
GROUP BY batter

#Dense Rank Bowlers by Wickets
SELECT bowler,SUM(is_wicket) AS wickets,
    DENSE_RANK() OVER (ORDER BY SUM(is_wicket) DESC) AS ranking
FROM deliveries
GROUP BY bowler;

#Row Number for Matches by Season
SELECT
    season,
    id,
    ROW_NUMBER() OVER(PARTITION BY season ORDER BY date) AS match_no
FROM matches;

#Top Scorer Using CTE
WITH batter_runs AS
(
SELECT
batter,
SUM(batsman_runs) AS runs
FROM deliveries
GROUP BY batter
)

SELECT *
FROM batter_runs
ORDER BY runs DESC
LIMIT 10;
#. Number of Super Over Matches by Season
SELECT
season,
COUNT(*) AS super_over_matches
FROM matches
WHERE super_over='Y'
GROUP BY season;

#Season-wise Champions (Based on Final Match Winner)
SELECT
season,
winner
FROM matches
WHERE match_type='Final';

#Teams Winning Toss and Match
SELECT
toss_winner,
COUNT(*) AS wins
FROM matches
WHERE toss_winner=winner
GROUP BY toss_winner
ORDER BY wins DESC;