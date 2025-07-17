SELECT 
job_schedule_type, 
AVG (salary_year_avg) AS avg_yearly_salary,
AVG (salary_hour_avg) AS avg_hourly_salary

FROM
job_postings_fact

WHERE
job_posted_date:: date > '2023-06-01'

GROUP BY
job_schedule_type

order BY
job_schedule_type;

SELECT

EXTRACT (MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS MONTH,
COUNT (*) AS total_post

FROM job_postings_fact

GROUP BY MONTH
order BY MONTH;

SELECT *
from company_dim

SELECT 
company_id

from job_postings_fact;


--PROBEMA 3: companies (include company name) that have posted 
--jobs offering health insurance,
--where these postings were made in the second quarter of 2023


SELECT 
company_dim.name AS COMPANY_NAME,
COUNT (job_postings_fact.job_id) AS total_post

FROM job_postings_fact

INNER JOIN company_dim
ON job_postings_fact.company_id = company_dim.company_id

where
job_health_insurance = true
AND EXTRACT(QUARTER FROM job_posted_date)= 2
AND EXTRACT(YEAR FROM job_posted_date) = 2023

GROUP BY company_dim.name
HAVING COUNT (*) > 0
order BY total_post DESC 
limit 5

/*
From the job_postings_fact table, categorize the salaries from job postings that are data analyst jobs 
and who have a yearly salary information. Put salary into 3 different categories:

If the salary_year_avg is greater than or equal to $100,000, then return ‘high salary’.
If the salary_year_avg is greater than or equal to $60,000 but less than $100,000, 
then return ‘Standard salary.’
If the salary_year_avg is below $60,000 return ‘Low salary’.
Also order from the highest to lowest salaries.
*/

SELECT
job_id,
job_title_short,
salary_year_avg,
CASE 

    WHEN salary_year_avg > 100000 THEN 'High salary'
    WHEN salary_year_avg BETWEEN 60000 AND 999999 THEN 'Standard salary'
    WHEN salary_year_avg < 60000  THEN 'Low salary'
 
END AS Salary_category

FROM job_postings_fact

WHERE
salary_year_avg is not null
AND job_title_short = 'Data Analyst'

ORDER BY salary_year_avg DESC;


/*
❓Question:

Count the number of unique companies that offer work from home (WFH)
 versus those requiring work to be on-site. Use the job_postings_fact table to count and 
 compare the distinct companies based on their WFH policy (job_work_from_home).

🔎 Hint:

Use COUNT with DISTINCT to find unique values.
CASE WHEN statements to separate companies based on their WFH policy.
The data will be from the job_postings_fact table.
*/

SELECT
COUNT (DISTINCT CASE WHEN job_work_from_home = true THEN company_id END) AS WFH_companies,
COUNT (DISTINCT CASE WHEN job_work_from_home = false THEN company_id END) AS non_wfh_companies

from job_postings_fact


/*
❓Question:

Write a query that lists all job postings with their job_id, salary_year_avg, 
and two additional columns using CASE WHEN statements called: experience_level 
and remote_option. Use the job_postings_fact table.

For experience_level, categorize jobs based on keywords found in their titles (job_title) 
as 'Senior', 'Lead/Manager', 'Junior/Entry', or 'Not Specified'.
Assume that certain keywords
 in job titles (like "Senior", "Manager", "Lead", "Junior", or "Entry") can indicate the level 
 of experience required. ILIKE should be used in place of LIKE for this.
NOTE: Use ILIKE in place of how you would normally use LIKE ; ILIKE is a command in SQL, 
specifically used in PostgreSQL. It performs a case-insensitive search, 
similar to the LIKE command but without sensitivity to case.
For remote_option, specify whether a job offers a remote option as either 'Yes' or 'No',
 based on job_work_from_home column.
🔎 Hint:

Use CASE WHEN to categorize data based on conditions.
Look for specific words that indicate job levels, like "Senior", "Manager", "Lead", 
"Junior", or "Entry". Use ILIKE to ensure the search for keywords is not case-sensitive.
For the remote work option based on job_work_from_home column and look at the boolean 
value in this column.
*/

-- que es ILIKE?? 

SELECT
job_id,
salary_year_avg,

CASE 
WHEN job_title ILIKE '%senior%' THEN 'Senior'
WHEN job_title ILIKE '%manager%' THEN 'Manager'
WHEN job_title ILIKE '%lead%'THEN 'Lead'
WHEN job_title ILIKE '%junior%'THEN 'Junior'
WHEN job_title ILIKE '%entry%'THEN 'Entry'
ELSE 'not specified'
END AS experience_level,

CASE
WHEN job_work_from_home = true THEN 'Si'
WHEN job_work_from_home = false THEN 'No'
END AS Remote_job

FROM job_postings_fact

WHERE salary_year_avg is not null 
ORDER BY salary_year_avg DESC;


/* What are the companies 

*/ 

SELECT 

company_id,
name AS COMPANY_NAME

FROM company_dim
WHERE company_id IN(
       
SELECT company_id
FROM job_postings_fact

WHERE 
job_no_degree_mention = true

ORDER BY company_id
)

WITH company_job_count AS (
SELECT 
company_id,
COUNT (*)

FROM job_postings_fact
GROUP BY company_id
)


/*
TOP 15 COMPANIES POST DATA JOBS 2023
*/

WITH company_job_count AS (
SELECT
company_id,
COUNT (*) AS total_jobs

FROM job_postings_fact
GROUP BY company_id
)
SELECT
company_dim.name AS company_name,
company_job_count.total_jobs

FROM 
company_dim
LEFT JOIN company_job_count ON 
company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC
limit 15


/* 
PROBLEM #7
FIND THE COUNT OF THE NUMBER OF REMOTE JOB POSTING PER SKILL

*/ 

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
job_postings_fact.job_title_short = 'Data Analyst' 

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



/* 


Problem Statement
Identify the top 5 skills that are most frequently mentioned in job postings.
 Use a subquery to find the skill IDs with the highest counts in the skills_job_dim table 
and then join this result with the skills_dim table to get the skill names.

*/ 

WITH remote_job_skills AS (
SELECT 
skills_job_dim.skill_id,
COUNT (*) AS skill_count

from 
skills_job_dim 

INNER JOIN job_postings_fact 
ON job_postings_fact.job_id = skills_job_dim.job_id

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
limit 5

/*
Determine the size category ('Small', 'Medium', or 'Large') for each company 
by first identifying the number of job postings they have. 
Use a subquery to calculate 
the total job postings per company. 
A company is considered 'Small' if it has less than 10 job postings, 
'Medium' if the number of job postings is between 10 and 50, 
and 'Large' if it has more than 50 job postings. 
Implement a subquery to aggregate job counts per company before classifying them based on size.

Hint
Aggregate job counts per company in the subquery. This involves grouping 
by company and counting job postings.
Use this subquery in the FROM clause of your main query.
In the main query, categorize companies based on the aggregated job counts 
from the subquery with a CASE statement.
The subquery prepares data (counts jobs per company), and the outer query classifies 
companies based on these counts.
*/

SELECT
job_counts.company_id,
company_dim.name AS name_company,
number_of_job,

CASE 
WHEN number_of_job < 10 THEN 'SMALL'
WHEN number_of_job BETWEEN 10 AND 50 THEN 'MEDIUM'
WHEN number_of_job > 50 THEN 'LARGE'

END AS size_category

FROM (
SELECT 
company_id,
COUNT (company_id) AS number_of_job

FROM job_postings_fact
GROUP BY company_id
) AS job_counts

INNER JOIN  company_dim
ON job_counts.company_id = company_dim.company_id

order BY company_id ASC


/* 
Problem Statement
Find companies that offer an average salary above the overall average yearly salary 
of all job postings. Use subqueries to select companies with an average salary higher 
than the overall average salary (which is another subquery).

Hint
Start by separating the task into two main steps:
Calculating the overall average salary
Identifying companies with higher averages.
Use a subquery (subquery 1) to find the average yearly salary across all job postings. 
Then join this subquery onto the company_dim table.
Use another subquery (subquery 2) to establish the overall average salary,
 which will help in filtering in the WHERE clause companies with higher average salaries.
Determine each company's average salary (what you got from subquery 1) 
and compare it to the overall average you calculated (subquery 2). 
Focus on companies that greater than this average.
*/ 

SELECT
name AS name_company,
avg_company,
job_title_short

FROM (
SELECT
job_postings_fact.company_id,
company_dim.name,
AVG(salary_year_avg) AS avg_company,
job_postings_fact.job_title_short


FROM 
job_postings_fact

INNER JOIN company_dim
ON job_postings_fact.company_id = company_dim.company_id

WHERE salary_year_avg IS NOT NULL
AND (job_title_short = 'Data Analyst'
OR job_title_short = 'Data Scientist')
GROUP BY 
job_postings_fact.company_id,
company_dim.name,
job_postings_fact.job_title_short

) AS average_company

WHERE 
avg_company > (
    SELECT 
    AVG(salary_year_avg)
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
)


ORDER BY avg_company ASC
limit 20

/* 
Identify companies with the most diverse (unique) job titles. 
se a CTE to count the number of unique job titles per company, 
then select companies with the highest diversity in job titles.
*/


WITH company_job_count AS (
    SELECT
    company_id,
    count (DISTINCT job_title) AS total_jobs
    FROM 
    job_postings_fact
    GROUP BY
    company_id
)
SELECT 
company_dim.name AS name_company,
company_job_count.total_jobs

FROM
company_job_count

INNER JOIN company_dim
ON company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC
limit 10

/* 
Problem Statement
Explore job postings by listing job id, job titles, company names, 
and their average salary rates, 
while categorizing these salaries relative to the average in their respective countries.
 Include the month of the job posted date. 
Use CTEs, conditional logic, and date functions, 
to compare individual salaries with national averages.

Hint
Define a CTE to calculate the average salary for each country. 
This will serve as a foundational dataset for comparison.
Within the main query, use a CASE WHEN statement to categorize 
each salary as 'Above Average' or 
'Below Average' based on its comparison (>) to the country's average salary calculated in the CTE.
To include the month of the job posting, use the EXTRACT function on the job posting date within your SELECT statement.
Join the job postings data (job_postings_fact) with the CTE to compare individual salaries to the average. 
Additionally, join with the company dimension (company_dim) table to get company names linked to each job posting.
*/


WITH average_final AS (

SELECT
job_country,
AVG (salary_year_avg) AS average_by_country
from
job_postings_fact


GROUP BY    -- where salary_year_avg is not NULL
job_country
)

SELECT
job_postings_fact.job_id,
job_postings_fact.job_title,
job_postings_fact.salary_year_avg,
company_dim.name,
EXTRACT (MONTH FROM job_posted_date) as MONTH_POST,

CASE 
WHEN job_postings_fact.salary_year_avg > average_final.average_by_country 
then 'Above Average'
ELSE 'Below Average'
END AS COMPARACION_SALARY

from 
job_postings_fact


INNER JOIN company_dim
ON company_dim.company_id = job_postings_fact.company_id

INNER JOIN
average_final 
ON job_postings_fact.job_country = average_final.job_country

ORDER BY MONTH_POST DESC -- where salary_year_avg is not NULL

/*

Calculate the number of unique skills required by each company. 
Aim to quantify the unique skills required per company and identify 
which of these companies offer the highest average salary for positions 
necessitating at least one skill. For entities without skill-related job postings, 
list it as a zero skill requirement and a null salary. 
Use CTEs to separately assess the unique skill count and 
the maximum average salary offered by these companies.
*/


WITH required_skills AS (
    SELECT  
        c.company_id,
        c.name AS company_name,
        COUNT(DISTINCT s.skill_id) AS unique_skills_required
    FROM skills_job_dim s
    LEFT JOIN job_postings_fact j ON j.job_id = s.job_id
    LEFT JOIN company_dim c ON c.company_id = j.company_id
    GROUP BY c.company_id, c.name
),

max_salary AS (
    SELECT
        job_postings.company_id,
        MAX(job_postings.salary_year_avg) AS highest_average_salary
    FROM
        job_postings_fact AS job_postings
    WHERE
        job_postings.job_id IN (SELECT job_id FROM skills_job_dim)
    GROUP BY
        job_postings.company_id
)

SELECT
    companies.name,
    required_skills.unique_skills_required as unique_skills_required, --handle companies w/o any skills required
    max_salary.highest_average_salary
FROM
    company_dim AS companies
LEFT JOIN required_skills ON companies.company_id = required_skills.company_id
LEFT JOIN max_salary ON companies.company_id = max_salary.company_id
ORDER BY
    companies.name;



-- vrespuesta: 

WITH required_skills AS (
    SELECT
        companies.company_id,
        COUNT(DISTINCT skills_to_job.skill_id) AS unique_skills_required
    FROM
        company_dim AS companies 
    LEFT JOIN job_postings_fact as job_postings ON companies.company_id = job_postings.company_id
    LEFT JOIN skills_job_dim as skills_to_job ON job_postings.job_id = skills_to_job.job_id
    GROUP BY
        companies.company_id
),
-- Gets the highest average yearly salary from the jobs that require at least one skills 
max_salary AS (
    SELECT
        job_postings.company_id,
        MAX(job_postings.salary_year_avg) AS highest_average_salary
    FROM
        job_postings_fact AS job_postings
    WHERE
        job_postings.job_id IN (SELECT job_id FROM skills_job_dim)
    GROUP BY
        job_postings.company_id
)
-- Joins 2 CTEs with table to get the query
SELECT
    companies.name,
    required_skills.unique_skills_required as unique_skills_required, --handle companies w/o any skills required
    max_salary.highest_average_salary
FROM
    company_dim AS companies
LEFT JOIN required_skills ON companies.company_id = required_skills.company_id
LEFT JOIN max_salary ON companies.company_id = max_salary.company_id
ORDER BY
    companies.name;
    
-- que es skill_dim
SELECT *
from skills_dim


-- conoteo de skill por job_id 
SELECT *
FROM skills_job_dim

where
job_id = '0'


/* USO DE "UNION  */ 

SELECT 
quarter1_job_posting.job_title_short,
quarter1_job_posting.job_location,
quarter1_job_posting.job_via,
quarter1_job_posting.job_posted_date::DATE,
quarter1_job_posting.salary_year_avg,
company_dim.name AS company_name

FROM (

    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1

    UNION ALL 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2

    UNION ALL 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3

) AS quarter1_job_posting

INNER JOIN company_dim
ON quarter1_job_posting.company_id = company_dim.company_id

WHERE 
quarter1_job_posting.salary_year_avg > 70000 AND
quarter1_job_posting.job_title_short = 'Data Analyst'

ORDER BY quarter1_job_posting.salary_year_avg DESC


/* Create a unified query that categorizes job postings into two groups: 
those with salary information (salary_year_avg or salary_hour_avg is not null) 
and those without it. Each job posting should be listed with its job_id, job_title,
 and an indicator of whether salary information is provided.

For the first query, filter job postings where either salary field is not null to identify 
postings with salary information

*/ 

(
    SELECT 
    job_id,
    job_title,
    'With Salary Info' AS salary_info

    FROM  job_postings_fact
    WHERE  salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
)
    UNION ALL 
(
    SELECT 
    job_id,
    job_title,
    'Without Salary Info' AS salary_info

    FROM  job_postings_fact
    WHERE salary_hour_avg IS NULL
AND salary_year_avg IS NULL
)

ORDER BY 
    salary_info DESC, 
    job_id; 


/* Problem Statement
Retrieve the job id, job title short, job location, job via, 
skill and skill type for each job posting from the first quarter (January to March). 
Using a subquery to combine job postings from the first quarter 
(these tables were created in the Advanced Section - Practice Problem 6 
[include timestamp of Youtube video]) Only include postings with an average yearly salary greater than $70,000.

Hint
Use UNION ALL to combine job postings from January, February, and March into a single dataset.
Apply a LEFT JOIN to include skills information, allowing for job postings without associated skills to be included.
Filter the results to only include job postings with an average yearly salary above $70,000. */ 


SELECT 
quarter1_job_posting.job_id,
quarter1_job_posting.job_title_short,
quarter1_job_posting.job_location,
quarter1_job_posting.job_via,
quarter1_job_posting.job_posted_date::DATE,
quarter1_job_posting.salary_year_avg,
skills_dim.skill_id,
skills_dim.skills,
skills_dim.type


FROM (

    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1

    UNION ALL 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2

    UNION ALL 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3

) AS quarter1_job_posting


LEFT JOIN skills_job_dim
    ON quarter1_job_posting.job_id = skills_job_dim.job_id

LEFT JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE quarter1_job_posting.salary_year_avg > 70000

ORDER BY
    quarter1_job_posting.job_id;


----
/*
Problem Statement
Analyze the monthly demand for skills by counting the number of job postings for each 
skill in the first quarter (January to March), utilizing data from separate tables for each month.
 Ensure to include skills from all job postings across these months. The tables for the first 
 quarter job postings were created in Practice Problem 6.

Hint
Use UNION ALL to combine job postings from January, February, and March into a consolidated dataset.
Apply the EXTRACT function to obtain the year and month from job posting dates, 
even though the month will be implicitly known from the source table.
Group the combined results by skill to summarize the total postings for each skill across the first quarter.
Join with the skills dimension table to match skill IDs with skill names. */ 


WITH month_posts_1  AS (

    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1

    UNION ALL 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2

    UNION ALL 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3

),

monthly_skill_demand AS (
    SELECT
        skills_dim.skills,  
        EXTRACT(YEAR FROM month_posts_1.job_posted_date) AS year,  
        EXTRACT(MONTH FROM month_posts_1.job_posted_date) AS month,  
        COUNT(month_posts_1.job_id) AS postings_count 
    FROM
        month_posts_1
    INNER JOIN skills_job_dim ON month_posts_1.job_id = skills_job_dim.job_id  
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id  
    GROUP BY
        skills_dim.skills, 
        year, 
        month

)
-- Main query to display the demand for each skill during the first quarter
SELECT
    skills,  
    year,  
    month,  
    postings_count 
FROM
    monthly_skill_demand
ORDER BY
    skills, 
    year,
    month;