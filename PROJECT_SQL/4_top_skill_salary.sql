/* 
QUESTION #4:

- What are the top skills based on salary for'Data Analyst' in Norway?
*/

SELECT 
skills,
ROUND(AVG (salary_year_avg),0) AS average_salary

from 
job_postings_fact 

INNER JOIN skills_job_dim 
ON job_postings_fact.job_id = skills_job_dim.job_id

INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id

where 
job_postings_fact.job_work_from_home = true AND
job_postings_fact.job_title_short = 'Data Analyst' 
AND job_postings_fact.job_country = 'Norway' 
-- AND job_postings_fact.salary_year_avg IS NOT NULL

GROUP BY skills

ORDER BY average_salary DESC
LIMIT 10;