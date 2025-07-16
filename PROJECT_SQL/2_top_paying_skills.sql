/* 
QUESTION #2: 

- What skills are required for the  15 top-paying for 'Data Analyst' in Norway?

*/
WITH top_paying_job AS (

    SELECT 
    job_id,
    job_title_short,
    job_location,
    salary_year_avg,
    company_dim.name AS Company_name,
    job_posted_date

    FROM job_postings_fact

    LEFT JOIN company_dim ON
    job_postings_fact.company_id = company_dim.company_id


    WHERE 
    job_title_short ='Data Analyst' AND
    job_country = 'Norway' AND
    salary_year_avg IS NOT NULL

    ORDER BY
    salary_year_avg DESC

    LIMIT 15
)

SELECT 
top_paying_job.*,
skills

FROM top_paying_job

INNER JOIN skills_job_dim
ON top_paying_job.job_id = skills_job_dim.job_id

INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id

ORDER BY salary_year_avg DESC
LIMIT 15;

----
/*
QUESTION #2: 

- What skills are required for the  15 top-paying for 'Data Analyst'
and 'Data Scientist' in Norway? */

WITH top_paying_job AS (

    SELECT 
    job_id,
    job_title_short,
    job_location,
    salary_year_avg,
    company_dim.name AS Company_name,
    job_posted_date

    FROM job_postings_fact

    LEFT JOIN company_dim ON
    job_postings_fact.company_id = company_dim.company_id


    WHERE 
    job_title_short IN ('Data Analyst','Data Scientist') AND
    job_country = 'Norway' AND
    salary_year_avg IS NOT NULL

    ORDER BY
    salary_year_avg DESC

    LIMIT 15
)

SELECT 
top_paying_job.*,
skills

FROM top_paying_job

INNER JOIN skills_job_dim
ON top_paying_job.job_id = skills_job_dim.job_id

INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id

ORDER BY salary_year_avg DESC
LIMIT 30