-- use data base
use olymp1;

-- check tables
show tables;

-- check data in each tables
SELECT 
    *
FROM
    olymp1.athlete_events;

SELECT 
    *
FROM
    noc_regions;

-- check counts of data in each tables
SELECT 
    COUNT(*)
FROM
    athlete_events;

SELECT 
    COUNT(*)
FROM
    noc_regions;

-- check null values in columns
-- from athlete_events;

SELECT 
    COUNT(CASE
        WHEN name IS NULL OR name IN ('NA') THEN id
    END) AS name_null_count,
    COUNT(CASE
        WHEN sex IS NULL OR sex IN ('NA') THEN id
    END) AS sex_null_cnt,
    COUNT(CASE
        WHEN Age IS NULL OR age IN ('NA') THEN id
    END) AS age_null_count,
    COUNT(CASE
        WHEN height IS NULL OR height IN ('NA') THEN id
    END) AS height_null_count,
    COUNT(CASE
        WHEN weight IS NULL OR weight IN ('NA') THEN id
    END) AS weight_null_count,
    COUNT(CASE
        WHEN Team IS NULL OR team IN ('NA') THEN id
    END) AS team_null_count,
    COUNT(CASE
        WHEN NOC IS NULL OR noc IN ('NA') THEN id
    END) AS NOC_null_count,
    COUNT(CASE
        WHEN games IS NULL OR games IN ('NA') THEN id
    END) AS games_null_count,
    COUNT(CASE
        WHEN year IS NULL OR year IN ('NA') THEN id
    END) AS year_null_count,
    COUNT(CASE
        WHEN season IS NULL OR season IN ('NA') THEN id
    END) AS season_null_cnt,
    COUNT(CASE
        WHEN city IS NULL OR city IN ('NA') THEN id
    END) AS city_null_count,
    COUNT(CASE
        WHEN sport IS NULL OR sport IN ('NA') THEN id
    END) AS sports_null_count,
    COUNT(CASE
        WHEN Event IS NULL OR event IN ('NA') THEN id
    END) AS event_null_count,
    COUNT(CASE
        WHEN Medal IS NULL OR medal IN ('NA') THEN id
    END) AS medal_null_count
FROM
    athlete_events;


-- from noc_regions

SELECT 
    *
FROM
    noc_regions;

SELECT 
    COUNT(CASE
        WHEN noc IS NULL THEN 1
    END) AS NOC_null_count,
    COUNT(CASE
        WHEN region IS NULL THEN 1
    END) AS region_null_count,
    COUNT(CASE
        WHEN notes IS NULL THEN 1
    END) AS notes_ull_count
FROM
    noc_regions;

-- check which country has more player in the game
SELECT 
    team, COUNT(team) cnt
FROM
    athlete_events
GROUP BY team
ORDER BY cnt DESC
LIMIT 5;

--- check if india has taken place

SELECT 
    team, COUNT(team) AS cnt
FROM
    athlete_events
WHERE
    team IN ('india');

with t1 
as 
	(select name, team, medal 
	from athlete_events),
t2 
as 
	(select name,  count(medal) as medal_count 
	from t1 group by name order by  medal_count  desc),
t3 
as 
	(select t2.name, team, medal_count 
	from t2 left join t1 on t2.name=t1.name)
    
		select distinct(name), team, medal_count 
	from t3 
		order by medal_count desc;

-- check gender count
SELECT 
    COUNT(CASE
        WHEN sex IN ('M') THEN 1
    END) AS Male_count,
    COUNT(CASE
        WHEN sex IN ('F') THEN 1
    END) AS Female_count
FROM
    athlete_events;
 -- other way   
with t1 as ( 
	select sex, count(sex) cnt , row_number() over (partition by sex  ) 
    as rank_Sex from athlete_events group by sex order by sex desc)
select sex, cnt, dense_rank() over (order by cnt desc) from t1 ;

-- check year wise games 
SELECT 
    year, COUNT(games) AS cnt
FROM
    athlete_events
GROUP BY year
ORDER BY cnt DESC;


-- check who won most gold
SELECT DISTINCT
    (medal)
FROM
    athlete_events;


with t1 as (select name, team, medal from athlete_events where medal ="gold"),
t2 as (select name, count(medal) cnt from t1  group by name)
select distinct(t2.name), t1.team, t2.cnt, t1.medal from t2 inner join t1 on t2.name=t1.name order by cnt desc;

-- check who won most bronze winner 

with t1 as (select name, team, medal from athlete_events where medal ="bronze"),
t2 as (select name, count(medal) cnt from t1  group by name)
select distinct(t2.name), t1.team, t2.cnt, t1.medal from t2 inner join t1 on t2.name=t1.name order by cnt desc;


-- check who won most silver winner 

with t1 as (select name, team, medal from athlete_events where medal ="silver"),
t2 as (select name, count(medal) cnt from t1  group by name)
select distinct(t2.name), t1.team, t2.cnt, t1.medal from t2 inner join t1 on t2.name=t1.name order by cnt desc;

--- check team wise height and weight
select team, height, weight, 
row_number() over(partition by team order by height desc) as height_rank,
row_number() over(partition by team order by weight desc) as weight_rank
from athlete_events where height not like "%na%" ;


-- year wise game and medals 
select year, 
count(case when games not in ("na") then games else 0 end) as games,
count(case when medal not in ("na") then medal else 0 end) as medals
from athlete_events group by year ;

--- year wise running total of medal by team

-- check running total year wise 
with t1 as (
select name,team,year, Medal  from athlete_events where medal !="NA"),
t2 as (
select year, count(Medal) as m_cnt from t1 group by year)
select name, t2.m_cnt,  team,t2.year, sum(m_cnt) over w2 as running_total from t2 inner join t1 on t1.year= t2.year
window w2 as ( rows unbounded preceding);


select * from noc_regions;
select * from noc_regions where noc regexp "ind";


