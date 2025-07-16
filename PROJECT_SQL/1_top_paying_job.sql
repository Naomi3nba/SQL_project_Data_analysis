/* 
Question 1: 

- What are the 15 top-paying job for 'Data Analyst'?
- Country = Norway
- Company Name

*/


SELECT 
job_id,
job_title_short,
job_location,
job_via,
job_schedule_type,
salary_year_avg,
company_dim.name AS Company_name,
job_posted_date

FROM job_postings_fact

LEFT JOIN company_dim ON
job_postings_fact.company_id = company_dim.company_id


WHERE 
job_title_short = 'Data Analyst' AND
job_country = 'Norway' AND
salary_year_avg IS NOT NULL

ORDER BY
salary_year_avg DESC

LIMIT 15


/* 
Question 1: 

- What are the 15 top-paying job for 'Data Analyst'and 'Data Scientist'?
- Country = Norway
- Company Name

*/


SELECT 
job_id,
job_title_short,
job_location,
job_via,
job_schedule_type,
salary_year_avg,
company_dim.name AS Company_name,
job_posted_date

FROM job_postings_fact

LEFT JOIN company_dim ON
job_postings_fact.company_id = company_dim.company_id


WHERE 
job_title_short IN ('Data Analyst', 'Data Scientist') AND
job_country = 'Norway' AND
salary_year_avg IS NOT NULL

ORDER BY
salary_year_avg DESC

LIMIT 15

