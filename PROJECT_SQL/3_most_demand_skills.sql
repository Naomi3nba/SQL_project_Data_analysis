/* 

QUESTION #3: 

- What are the most in-demand skills for 'Data Analyst' in Norway?

*/


SELECT 
skills,
COUNT (skills_job_dim.job_id) AS demand_count

from 
job_postings_fact 

INNER JOIN skills_job_dim 
ON job_postings_fact.job_id = skills_job_dim.job_id

INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id

where 
job_postings_fact.job_work_from_home = true AND
job_postings_fact.job_title_short = 'Data Analyst' AND
job_postings_fact.job_country = 'Norway'

GROUP BY skills

ORDER BY demand_count DESC
LIMIT 5;






---- 
/* Problem #7*/ 

WITH remote_job_skills AS (
SELECT 
skills_job_dim.skill_id,
COUNT (*) AS skill_count

from 
skills_job_dim 

INNER JOIN job_postings_fact 
ON job_postings_fact.job_id = skills_job_dim.job_id

where 
job_postings_fact.job_work_from_home = true AND
job_postings_fact.job_title_short = 'Data Analyst' AND
job_postings_fact.job_country = 'Norway'

GROUP BY 
skills_job_dim.skill_id
)

SELECT
skills_dim.skill_id,
skills_dim.skills AS skill_name,
skill_count

from remote_job_skills

INNER JOIN skills_dim
ON skills_dim.skill_id = remote_job_skills.skill_id

ORDER BY skill_count DESC
LIMIT 5
