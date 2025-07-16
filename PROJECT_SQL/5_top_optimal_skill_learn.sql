/* 
QUESTION #5: 

What are the most optimal skills to learn?

*/

WITH skills_demand AS (
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT (skills_job_dim.job_id) AS demand_count,
    job_country

    from 
    job_postings_fact 

    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id

    INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id

    where 
    --job_country IN ('Norway', 'Sweden') AND
    job_postings_fact.job_country = 'Norway' AND
    job_postings_fact.job_work_from_home = true AND
    job_postings_fact.job_title_short = 'Data Analyst'
    

    GROUP BY 
    skills_dim.skill_id, 
    skills_dim.skills,
    job_postings_fact.job_country

), average_salary AS(
    SELECT 
    skills_job_dim.skill_id,
    skills,
    ROUND(AVG (salary_year_avg),0) AS avg_salary

    from 
    job_postings_fact 

    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id

    INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id

    where 

    -- job_country IN ('Norway', 'Sweden') AND
    job_postings_fact.job_country = 'Norway' AND
    job_postings_fact.job_work_from_home = true AND
    job_postings_fact.job_title_short = 'Data Analyst'
    
    -- AND job_postings_fact.salary_year_avg IS NOT NULL

    GROUP BY 
    skills_job_dim.skill_id, 
    skills_dim.skills,
    job_postings_fact.job_country

)

SELECT
skills_demand.skill_id,
skills_demand.skills,
demand_count,
avg_salary,
job_country

FROM skills_demand

INNER JOIN average_salary 
ON skills_demand.skill_id = average_salary.skill_id

ORDER BY
demand_count DESC,
avg_salary DESC

LIMIT 20